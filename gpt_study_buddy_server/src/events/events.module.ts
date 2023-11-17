import { Module } from '@nestjs/common';
import { EventsService } from './events.service';
import { EventsController } from './events.controller';
import {
  EventMapper,
  EventsRepository,
  EventsRepositoryImpl,
} from './events.repository';
import { UsersModule } from '../users/users.module';
import { EventsGptFunctionHanlder } from './events_gpt_functions';

@Module({
  providers: [
    EventsService,
    EventMapper,
    {
      provide: EventsRepository,
      useClass: EventsRepositoryImpl,
    },
    EventsGptFunctionHanlder,
  ],
  controllers: [EventsController],
  imports: [UsersModule],
  exports: [EventsService, EventsRepository, EventsGptFunctionHanlder],
})
export class EventsModule {}
