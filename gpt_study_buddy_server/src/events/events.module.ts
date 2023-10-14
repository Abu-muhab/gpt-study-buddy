import { Module } from '@nestjs/common';
import { EventsService } from './events.service';
import { EventsController } from './events.controller';
import {
  EventMapper,
  EventsRepository,
  EventsRepositoryImpl,
} from './events.repository';
import { UsersModule } from '../users/users.module';

@Module({
  providers: [
    EventsService,
    EventMapper,
    {
      provide: EventsRepository,
      useClass: EventsRepositoryImpl,
    },
  ],
  controllers: [EventsController],
  imports: [UsersModule],
  exports: [EventsService, EventsRepository],
})
export class EventsModule {}
