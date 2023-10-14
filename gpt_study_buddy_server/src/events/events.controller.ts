import { Body, Controller, Get, Post, Query, UseFilters } from '@nestjs/common';
import { EventsService } from './events.service';
import { EventsRepository } from './events.repository';
import { User } from '../users/user.model';
import { UserDecorator } from '../users/user.decorator';
import { CreateEventRequest, EventDto } from './events.dto';
import { ApiCreatedResponse, ApiOperation } from '@nestjs/swagger';
import { HttpDomainExceptionFilter } from '../common/http_domain_exception_filter';

@Controller('events')
@UseFilters(HttpDomainExceptionFilter)
export class EventsController {
  constructor(
    private readonly eventsService: EventsService,
    private readonly eventsRepository: EventsRepository,
  ) {}

  @Post()
  @ApiOperation({ summary: 'Create a new event' })
  @ApiCreatedResponse({
    description: 'The event has been successfully created.',
    type: EventDto,
  })
  async createEvent(
    @UserDecorator() user: User,
    @Body() body: CreateEventRequest,
  ): Promise<EventDto> {
    const event = await this.eventsService.createEvent({
      name: body.name,
      startDate: new Date(body.startTime),
      endDate: new Date(body.endTime),
      isAllDay: body.isAllDay,
      userId: user.id,
    });
    return EventDto.fromDomain(event);
  }

  @Get()
  @ApiOperation({ summary: 'Get all events for the current user' })
  async getUserEvents(
    @UserDecorator() user: User,
    @Query('startTime') start: string,
    @Query('endTime') end: string,
  ): Promise<EventDto[]> {
    const events = await this.eventsRepository.getUserEventBetweenDates({
      userId: user.id,
      startDate: new Date(start),
      endDate: new Date(end),
    });
    return events.map((event) => EventDto.fromDomain(event));
  }
}
