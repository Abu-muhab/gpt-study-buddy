import { Injectable } from '@nestjs/common';
import axios, { AxiosResponse } from 'axios';
import { Message } from './message.model.js';
import { UsersRepository } from '../users/user.repository.js';
import { Bot } from '../bots/bot.model.js';
import { BotsRepository } from '../bots/bots.repository.js';
import { NotesRepository } from '../notes/notes.repository.js';
import { EventsService } from '../events/events.service.js';
import { EventsRepository } from '../events/events.repository.js';
import { EventDto } from '../events/events.dto.js';
import { NotesService } from '../notes/notes.service.js';
import { PptService } from '../ppt/ppt.service.js';

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
    private readonly pptService: PptService,
  ) {}

  private async generateImage(prompt: string): Promise<string> {
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
      } catch (err) {
        console.log(err.response.data);
        throw err;
      }
      const responseMessage = response.data.choices[0]['message'];

      if (responseMessage['function_call']) {
        const callableFunction = this.callableFunctions.find(
          (f) => f.name === responseMessage['function_call']['name'],
        );
        const requiresArguments = !!callableFunction.parameters;

        // console.log(responseMessage['function_call']['arguments']);
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
        content: "Don't include any whitespace when generating JSONs",
      },
      {
        role: 'system',
        content: "Don't include any explanations or comments in JSONs",
      },
      {
        role: 'system',
        content: 'Ensure that all JSONs are valid',
      },
      {
        role: 'system',
        content:
          "Don't make assumtioons about what vakues to plug into functions",
      },
      {
        role: 'system',
        content:
          'When creating a powerpoint (ppt), know that the default size is 10 x 5.625 inches',
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
        name: 'generate_image',
        description:
          'Generates an image based on the given prompt. The image is returned as a URL. Note: Use this exclusively when you need images for powerpoint (ppt) creation.',
        parameters: {
          type: 'object',
          required: ['prompt'],
          properties: {
            prompt: {
              type: 'string',
              description: 'The prompt to generate the image from.',
            },
          },
        },
      },
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
      {
        name: 'create_ppt',
        description: 'Create a ppt for the user with the given user ID',
        parameters: {
          type: 'object',
          required: ['userId', 'title', 'slides', 'author', 'subject'],
          properties: {
            userId: {
              type: 'string',
              description: 'The user id of the user to create the ppt for.',
            },
            title: {
              type: 'string',
              description: 'The title of the ppt.',
            },
            author: {
              type: 'string',
              description: 'The author of the ppt.',
            },
            subject: {
              type: 'string',
              description: 'The subject of the ppt.',
            },
            slides: {
              type: 'array',
              items: {
                type: 'object',
                required: ['elements'],
                properties: {
                  elements: {
                    type: 'array',
                    items: {
                      type: 'object',
                      required: ['type', 'layoutOptions'],
                      properties: {
                        type: {
                          type: 'string',
                          description: 'The type of the element.',
                        },
                        text: {
                          type: 'string',
                          description:
                            'The value of the element if it is a text element.',
                        },
                        src: {
                          type: 'string',
                          description:
                            'The source of the element if it is an image element.',
                        },
                        layoutOptions: {
                          type: 'object',
                          description: 'The layout options of the element.',
                          required: ['x', 'y', 'w', 'h'],
                          properties: {
                            x: {
                              type: 'number',
                              description:
                                'The x position of the element (inches)',
                            },
                            y: {
                              type: 'number',
                              description:
                                'The y position of the element (inches)',
                            },
                            w: {
                              type: 'string',
                              description:
                                'The width of the element (percent) ',
                            },
                            h: {
                              type: 'string',
                              description:
                                'The height of the element (percent)',
                            },
                            fontSize: {
                              type: 'number',
                              description:
                                'The font size of the text element (points). This is optional',
                            },
                            bold: {
                              type: 'boolean',
                              description:
                                'Whether or not the text element is bold. This is optional',
                            },
                          },
                        },
                      },
                    },
                  },
                },
              },
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
      case 'create_ppt':
        const ppt = await this.pptService.createPresentation(args);
        return {
          result: JSON.stringify({
            message: 'PPT created successfully',
          }),
          createdResources: [],
        };
      case 'generate_image':
        const image = await this.generateImage(args.prompt);
        console.log(image);
        return {
          result: image,
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
