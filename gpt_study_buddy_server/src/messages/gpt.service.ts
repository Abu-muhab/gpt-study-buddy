import { Injectable } from '@nestjs/common';
import axios from 'axios';
import { Message } from './message.model.js';
import { UsersRepository } from '../users/user.repository.js';
import { Bot } from '../bots/bot.model.js';
import { BotsRepository } from '../bots/bots.repository.js';
import { NotesRepository } from '../notes/notes.repository.js';
import { EventsService } from '../events/events.service.js';
import { EventsRepository } from '../events/events.repository.js';
import { EventDto } from '../events/events.dto.js';
import { Note } from '../notes/notes.model.js';
import { NotesService } from '../notes/notes.service.js';

interface CallableFunction {
  name: string;
  description: string;
  parameters?: object;
}

export enum CompletionCreatedResourceType {
  event = 'event',
}

export interface CompletionCreatedResource {
  type: CompletionCreatedResourceType;
  resource: Object;
}

export interface CompletionResult {
  completion: string;
  createdResources: CompletionCreatedResource[];
}

@Injectable()
export class GptService {
  constructor(
    private readonly userRepository: UsersRepository,
    private readonly botsRepository: BotsRepository,
    private readonly notesRepository: NotesRepository,
    private readonly notesService: NotesService,
    private readonly eventsService: EventsService,
    private readonly eventsRepository: EventsRepository,
  ) {}

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
          stream: false,
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

        let args: Object = JSON.parse(
          responseMessage['function_call']['arguments'],
        );

        if (callableFunction == null || (requiresArguments && args == null)) {
          return {
            completion: null,
            createdResources: [],
          };
        }

        const functionResponse = await this.callCallableFunction(
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
        content: 'Do',
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
          'This function returns the current date and time in the ISO string format (e.g., 2021-06-13T15:00:00.000Z). Use it when you need to calculate future dates in reference to the current date and time.',
        parameters: {
          type: 'object',
          required: [],
          properties: {},
        },
      },
      {
        name: 'create_event',
        description:
          "Create an event for the user with the given user ID and add it to the user's schedule or calendar. Use this only when you need to add a single event.",
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
              description:
                'The start date of the event in ISO string format. e.g 2021-06-13T15:00:00.000Z',
            },
            endDate: {
              type: 'string',
              description:
                'The end date of the event in ISO string format. e.g 2021-06-13T15:00:00.000Z',
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
              description:
                'The start date of the event in ISO string format. e.g 2021-06-13T15:00:00.000Z',
            },
            endDate: {
              type: 'string',
              description:
                'The end date of the event in ISO string format. e.g 2021-06-13T15:00:00.000Z',
            },
          },
        },
      },
      {
        name: 'create_note',
        description:
          'Create a note for the user with the given user ID and add it to the user notes. Use this only when you need to add a single note.',
        parameters: {
          type: 'object',
          required: ['userId', 'title', 'content'],
          properties: {
            userId: {
              type: 'string',
              description: 'The user id of the user to create the note for.',
            },
            title: {
              type: 'string',
              description: 'The title of the note.',
            },
            content: {
              type: 'string',
              description: 'The content of the note.',
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
  ): Promise<{
    result: string;
    createdResources: CompletionCreatedResource[];
  }> {
    switch (callableFunction.name) {
      case 'get_user_information':
        const response = await this.userRepository.findById(args.userId);
        return {
          result: JSON.stringify(response),
          createdResources: [],
        };
      case 'get_user_bots':
        const bots = await this.botsRepository.getUserBots(args.userId);
        return {
          result: JSON.stringify(bots),
          createdResources: [],
        };
      case 'get_user_notes':
        const notes = await this.notesRepository.getUserNotes(args.userId);
        return {
          result: JSON.stringify(notes),
          createdResources: [],
        };
      case 'create_note':
        const note = await this.notesService.createNote({
          title: args.title,
          content: args.content,
          userId: args.userId,
        });
        return {
          result: JSON.stringify(note),
          createdResources: [],
        };
      case 'create_event':
        console.log(args.userId);
        const event = await this.eventsService.createEvent({
          userId: args.userId,
          name: args.name,
          startDate: new Date(args.startDate),
          endDate: new Date(args.endDate),
          isAllDay: args.isAllDay,
        });
        return {
          result: JSON.stringify(event),
          createdResources: [
            {
              type: CompletionCreatedResourceType.event,
              resource: EventDto.fromDomain(event),
            },
          ],
        };
      case 'get_current_date_time':
        const date = new Date();
        return {
          result: date.toISOString(),
          createdResources: [],
        };
      case 'get_events':
        return {
          result: JSON.stringify(
            await this.eventsRepository.getUserEventBetweenDates({
              userId: args.userId,
              startDate: new Date(args.startDate),
              endDate: new Date(args.endDate),
            }),
          ),
          createdResources: [],
        };
      default:
        return {
          result: '',
          createdResources: [],
        };
    }
  }
}
