import { Injectable } from '@nestjs/common';
import axios from 'axios';
import { Message } from './message.model.js';
import { UsersRepository } from '../users/user.repository.js';
import { Bot } from '../bots/bot.model.js';
import { BotsRepository } from '../bots/bots.repository.js';

interface CallableFunction {
  name: string;
  description: string;
  parameters?: object;
}

@Injectable()
export class GptService {
  constructor(
    private readonly userRepository: UsersRepository,
    private readonly botsRepository: BotsRepository,
  ) {}

  private async getChatCompletion(
    messages: {
      role: string;
      content: string;
      name?: string;
    }[],
    chatBot: Bot,
  ): Promise<string | undefined | null> {
    try {
      const response = await axios.post(
        'https://api.openai.com/v1/chat/completions',
        {
          model: 'gpt-3.5-turbo',
          messages: messages,
          n: 1,
          temperature: 1,
          presence_penalty: 1,
          frequency_penalty: 1,
          functions: this.callableFunctions,
        },
        {
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${process.env.OPENAI_API_KEY}`,
          },
        },
      );
      const responseMessage = response.data.choices[0]['message'];

      if (responseMessage['function_call']) {
        const callableFunction = this.callableFunctions.find(
          (f) => f.name === responseMessage['function_call']['name'],
        );
        const requiresArguments = !!callableFunction.parameters;

        const args: Object = JSON.parse(
          responseMessage['function_call']['arguments'],
        );

        if (callableFunction == null || (requiresArguments && args == null)) {
          return null;
        }

        const functionResponse = await this.callCallableFunction(
          callableFunction,
          args,
        );

        messages.push(responseMessage);
        messages.push({
          role: 'function',
          name: callableFunction.name,
          content: functionResponse,
        });

        return await this.getChatCompletion(messages, chatBot);
      }

      return responseMessage.content;
    } catch (e) {
      if (e.response) {
        console.log(e.response.headers, e.response.status, e.response.data);
      } else {
        console.log(e);
      }
    }
  }

  async getCompletetionFromMessages(
    userId: string,
    messages: Message[],
    chatBot: Bot,
  ): Promise<string> {
    const systemMessgages = [
      {
        role: 'system',
        content: chatBot.description,
      },
      {
        role: 'system',
        content: "The id of the user you're talking to is " + userId,
      },
    ];

    return await this.getChatCompletion(
      [
        ...systemMessgages,
        ...messages.map((m) => {
          return {
            role: 'user',
            content: m.message,
          };
        }),
      ],
      chatBot,
    );
  }

  private get callableFunctions(): CallableFunction[] {
    const callableFunctions: CallableFunction[] = [
      {
        name: 'get_user_information',
        description:
          'Returns information about the user such as the firstName, lastName and email.',
        parameters: {
          type: 'object',
          required: ['userId'],
          properties: {
            userId: {
              type: 'string',
              description: 'The user id of the user to get information from.',
            },
          },
        },
      },
      {
        name: 'get_user_bots',
        description:
          'Returns the bots that the user with the given user id has created.',
        parameters: {
          type: 'object',
          required: ['userId'],
          properties: {
            userId: {
              type: 'string',
              description: 'The user id of the user to get bots from.',
            },
          },
        },
      },
    ];

    return callableFunctions;
  }

  private async callCallableFunction(
    callableFunction: CallableFunction,
    args: any,
  ): Promise<string> {
    switch (callableFunction.name) {
      case 'get_user_information':
        const response = await this.userRepository.findById(args.userId);
        return JSON.stringify(response);
      case 'get_user_bots':
        const bots = await this.botsRepository.getUserBots(args.userId);
        return JSON.stringify(bots);
      default:
        return '';
    }
  }
}
