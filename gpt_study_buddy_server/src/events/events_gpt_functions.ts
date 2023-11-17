import { Injectable } from '@nestjs/common';
import { EventDto } from './events.dto';
import { EventsRepository } from './events.repository';
import { EventsService } from './events.service';
import {
  CompletionCreatedResource,
  CompletionCreatedResourceType,
  GptFunction,
  GptFunctionHandler,
} from '../messages/gpt.model';

@Injectable()
export class EventsGptFunctionHanlder extends GptFunctionHandler {
  constructor(
    private readonly eventsService: EventsService,
    private readonly eventsRepository: EventsRepository,
  ) {
    super();
  }
  get handledFunctions(): GptFunction[] {
    return [
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
    ];
  }

  async handleFunction(params: {
    functionName: string;
    args: object;
  }): Promise<{
    result: string;
    createdResources: CompletionCreatedResource[];
  }> {
    const args = params.args as any;
    switch (params.functionName) {
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
        throw new Error('Function not implemented');
    }
  }
}
