import { Injectable } from '@nestjs/common';
import axios from 'axios';
import { Message } from './message.model.js';
import { UsersRepository } from '../users/user.repository.js';
import { Bot } from '../bots/bot.model.js';
import { BotsRepository } from '../bots/bots.repository.js';
import { NotesRepository } from '../notes/notes.repository.js';
import { EventsService } from '../events/events.service.js';
import { EventsRepository } from '../events/events.repository.js';

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
    private readonly notesRepository: NotesRepository,
    private readonly eventsService: EventsService,
    private readonly eventsRepository: EventsRepository,
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
          model: 'gpt-4',
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

        console.log(`calling function ${callableFunction.name}`);
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
      {
        name: 'get_user_notes',
        description:
          'Returns notes that the user with the given user id has created. Can include notes such as learning notes, meeting notes, etc.',
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
      {
        name: 'get_current_date_time',
        description:
          'Returns the current date and time in the ISO string format.',
        parameters: {
          type: 'object',
          required: [],
          properties: {},
        },
      },
      {
        name: 'create_event',
        description:
          'Creates an event for the user with the given user id and adds it to the users schedule/calendar.',
        parameters: {
          type: 'object',
          required: ['userId', 'name', 'startDate', 'endDate', 'isAllDay'],
          properties: {
            userId: {
              type: 'string',
              description: 'The user id of the user to create the event for.',
            },
            name: {
              type: 'string',
              description: 'The name of the event.',
            },
            startDate: {
              type: 'string',
              description: 'The start date of the event in ISO string format.',
            },
            endDate: {
              type: 'string',
              description: 'The end date of the event in ISO string format.',
            },
            isAllDay: {
              type: 'boolean',
              description: 'Whether or not the event is all day.',
            },
          },
        },
      },
      {
        name: 'get_events',
        description:
          'Returns the events for the user for the given time period.',
        parameters: {
          type: 'object',
          required: ['userId', 'startDate', 'endDate'],
          properties: {
            userId: {
              type: 'string',
              description: 'The user id of the user to get events from.',
            },
            startDate: {
              type: 'string',
              description: 'The start date of the event in ISO string format.',
            },
            endDate: {
              type: 'string',
              description: 'The end date of the event in ISO string format.',
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
      case 'get_user_notes':
        const notes = await this.notesRepository.getUserNotes(args.userId);
        return JSON.stringify(notes);
      case 'create_event':
        const event = await this.eventsService.createEvent({
          userId: args.userId,
          name: args.name,
          startDate: new Date(args.startDate),
          endDate: new Date(args.endDate),
          isAllDay: args.isAllDay,
        });
        return JSON.stringify(event);
      case 'get_current_date_time':
        const date = new Date();
        return date.toISOString();
      case 'get_events':
        const events = await this.eventsRepository.getUserEventBetweenDates({
          userId: args.userId,
          startDate: new Date(args.startDate),
          endDate: new Date(args.endDate),
        });
        return JSON.stringify(events);
      default:
        return '';
    }
  }
}
