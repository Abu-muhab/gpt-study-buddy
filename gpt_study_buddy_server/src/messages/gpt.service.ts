import { Injectable } from '@nestjs/common';
import axios, { AxiosResponse } from 'axios';
import { Message } from './message.model';
import { Bot } from '../bots/bot.model';
import { BotsGptFunctionHandler } from '../bots/bots_gpt_functions';
import { NotesGptFunctionHanlder } from '../notes/notes_gpt_functions';
import { InternalGptFunctionHandler } from './internal_gpt_functions';
import { UsersGptFunctionHandler } from '../users/users_gpt_functions';
import { PptGptFunctionHanlder } from '../ppt/ppt_gpt_functions';
import {
  CompletionCreatedResource,
  CompletionResult,
  GptFunctionHandler,
  GptFunction,
} from './gpt.model';

@Injectable()
export class GptService {
  constructor(
    private readonly notesGptFunctionHandler: NotesGptFunctionHanlder,
    private readonly botsGptFunctionHandler: BotsGptFunctionHandler,
    private readonly usersGptFunctionHandler: UsersGptFunctionHandler,
    private readonly pptGptFunctionHandler: PptGptFunctionHanlder,
  ) {}

  async generateImage(prompt: string): Promise<string> {
    try {
      let response: AxiosResponse;
      try {
        response = await axios.post(
          'https://api.openai.com/v1/images/generations',
          {
            model: 'dall-e-3',
            prompt: prompt,
            n: 1,
            size: '1024x1024',
          },
          {
            headers: {
              'Content-Type': 'application/json',
              Authorization: `Bearer ${process.env.OPENAI_API_KEY}`,
            },
          },
        );
      } catch (err) {
        console.log(err.response.data);
        throw err;
      }
      return response.data.data[0].url;
    } catch (e) {
      if (e.response) {
        console.log(e.response.headers, e.response.status, e.response.data);
      } else {
        console.log(e);
      }

      throw e;
    }
  }

  private async getChatCompletion(
    messages: {
      role: string;
      content: string;
      name?: string;
    }[],
    systemMessages: {
      role: string;
      content: string;
      name?: string;
    }[],
    chatBot: Bot,
    createdResources?: CompletionCreatedResource[],
  ): Promise<CompletionResult> {
    if (createdResources == null || createdResources == undefined) {
      createdResources = [];
    }

    if (messages.length > 10) {
      messages = messages.slice(messages.length - 10, messages.length);
    }
    messages = [...systemMessages, ...messages];

    try {
      let response: AxiosResponse;
      try {
        response = await axios.post(
          'https://api.openai.com/v1/chat/completions',
          {
            model: 'gpt-4-1106-preview',
            messages: messages,
            n: 1,
            top_p: 0.8,
            functions: this.gptFunctions,
            stream: false,
          },
          {
            headers: {
              'Content-Type': 'application/json',
              Authorization: `Bearer ${process.env.OPENAI_API_KEY}`,
            },
          },
        );
      } catch (err) {
        console.log(err.response.data);
        throw err;
      }
      const responseMessage = response.data.choices[0]['message'];

      if (responseMessage['function_call']) {
        const callableFunction = this.gptFunctions.find(
          (f) => f.name === responseMessage['function_call']['name'],
        );
        const requiresArguments = !!callableFunction.parameters;

        let args: Object = JSON.parse(
          responseMessage['function_call']['arguments'],
        );

        if (callableFunction == null || (requiresArguments && args == null)) {
          return {
            completion: null,
            createdResources: [],
          };
        }

        const functionResponse = await this.callGptFunction(
          callableFunction,
          args,
        );

        messages.push(responseMessage);
        messages.push({
          role: 'function',
          name: callableFunction.name,
          content: functionResponse.result,
        });

        createdResources.push(...functionResponse.createdResources);
        return await this.getChatCompletion(
          messages,
          systemMessages,
          chatBot,
          createdResources,
        );
      }

      return {
        completion: responseMessage.content,
        createdResources: createdResources,
      };
    } catch (e) {
      if (e.response) {
        console.log(e.response.headers, e.response.status, e.response.data);
      } else {
        console.log(e);
      }

      return {
        completion: null,
        createdResources: [],
      };
    }
  }

  async getCompletetionFromMessages(
    userId: string,
    messages: Message[],
    chatBot: Bot,
  ): Promise<CompletionResult> {
    const systemMessgages = [
      {
        role: 'system',
        content: chatBot.description,
      },
      {
        role: 'system',
        content: 'Current userId: ' + userId,
      },
      {
        role: 'system',
        content: `When creating a PowerPoint (PPT), adhere strictly to the default size of 10 x 5.625 inches. Ensure that all elements remain within the slide bounds, avoiding overlap or exceeding the designated limits. Additionally, include detailed content in your presentation, incorporating ample text, examples, explanations and images. Be as detailed as possible unless instructed otherwise. Always incorporate images, and generate them using the 'generate_image' function. Refrain from adding images from external sources. Furthermore, create new slides as necessary, particularly when content overflows the confines of a single slide. Following these guidelines will contribute to a visually appealing and well-organized presentation.
        `,
      },
    ];

    return await this.getChatCompletion(
      [
        ...messages.map((m) => {
          return {
            role: 'user',
            content: m.message,
          };
        }),
      ],
      systemMessgages,
      chatBot,
    );
  }

  private get gptFunctionHandlers(): GptFunctionHandler[] {
    return [
      new InternalGptFunctionHandler(this),
      this.botsGptFunctionHandler,
      this.notesGptFunctionHandler,
      this.usersGptFunctionHandler,
      this.pptGptFunctionHandler,
    ];
  }

  private get gptFunctions(): GptFunction[] {
    return this.gptFunctionHandlers
      .map((h) => h.handledFunctions)
      .reduce((a, b) => a.concat(b), []);
  }

  private async callGptFunction(
    gptFunction: GptFunction,
    args: any,
  ): Promise<{
    result: string;
    createdResources: CompletionCreatedResource[];
  }> {
    const handler = this.gptFunctionHandlers.find(
      (h) =>
        h.handledFunctions.find((f) => f.name === gptFunction.name) != null,
    );

    if (handler == null) {
      throw new Error(`No handler found for function ${gptFunction.name}`);
    }

    console.log(
      'Calling function',
      gptFunction.name,
      args,
      `with handler ${handler.constructor.name}`,
    );

    const response = await handler.handleFunction({
      functionName: gptFunction.name,
      args: args,
    });

    for (const resource of response.createdResources) {
      console.log('Created resource', JSON.stringify(resource));
    }

    return response;
  }
}
