import { Injectable } from '@nestjs/common';
import { EventsRepository } from './events.repository';
import { Event } from './event.model';
import { UsersRepository } from '../users/user.repository';
import { UserError } from '../users/user.errors';

@Injectable()
export class EventsService {
  constructor(
    private readonly eventsRepository: EventsRepository,
    protected readonly usersRepository: UsersRepository,
  ) {}
  async createEvent(params: Partial<Event>): Promise<Event> {
    const user = await this.usersRepository.findById(params.userId);
    if (!user) {
      throw new UserError.UserNotFound();
    }

    const event = new Event({
      id: await this.eventsRepository.nextId(),
      name: params.name,
      startTime: params.startDate,
      endTime: params.endDate,
      isAllDay: params.isAllDay,
      userId: params.userId,
    });
    await this.eventsRepository.add(event);
    return event;
  }

  async createEvents(params: Partial<Event>[]): Promise<Event[]> {
    const events = [];
    for (const event of params) {
      events.push(await this.createEvent(event));
    }
    return events;
  }
}
