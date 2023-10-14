import { Schema, model } from 'mongoose';
import { Repository } from '../common/repository';
import { Event } from './event.model';
import { Injectable } from '@nestjs/common';
import { MongoDbRepository } from '../common/mongodb_repository';
import { DomainError, DomainErrorType } from '../common/domain_error';

export abstract class EventsRepository extends Repository<Event> {
  abstract getUserEventBetweenDates(params: {
    userId: string;
    startDate: Date;
    endDate: Date;
  }): Promise<Event[]>;
}

export interface EventDocument {
  id: string;
  name: string;
  startTime: Date;
  endTime: Date;
  isAllDay: boolean;
  userId: string;
}

const eventSchema = new Schema<EventDocument>({
  id: { type: String, required: true },
  name: { type: String, required: true },
  startTime: { type: Date, required: true },
  endTime: { type: Date, required: true },
  isAllDay: { type: Boolean, required: true },
  userId: { type: String, required: true },
});

const EventModel = model<EventDocument>('Event', eventSchema);

@Injectable()
export class EventMapper {
  toPersistence(entity: Event): EventDocument {
    if (!entity) return null;
    return {
      id: entity.id,
      name: entity.name,
      startTime: entity.startDate,
      endTime: entity.endDate,
      isAllDay: entity.isAllDay,
      userId: entity.userId,
    };
  }
  toDomain(document: EventDocument): Event {
    if (!document) return null;
    return new Event({
      id: document.id,
      name: document.name,
      startTime: document.startTime,
      endTime: document.endTime,
      isAllDay: document.isAllDay,
      userId: document.userId,
    });
  }
}

@Injectable()
export class EventsRepositoryImpl
  extends MongoDbRepository<Event, EventDocument>
  implements EventsRepository
{
  constructor(mapper: EventMapper) {
    super(EventModel, mapper);
  }

  async getUserEventBetweenDates(params: {
    userId: string;
    startDate: Date;
    endDate: Date;
  }): Promise<Event[]> {
    const { userId, startDate, endDate } = params;
    const endEarlierThanStart = startDate.getTime() > endDate.getTime();
    if (endEarlierThanStart) {
      throw new DomainError(
        DomainErrorType.BadRequest,
        'startTime must be before endTime',
      );
    }

    const events = await this.model.find({
      userId,
      startTime: {
        $gte: new Date(startDate.setHours(0, 0, 0, 0)),
        $lte: new Date(endDate.setHours(23, 59, 59, 999)),
      },
    });
    return events.map((event) => this.mapper.toDomain(event));
  }
}
