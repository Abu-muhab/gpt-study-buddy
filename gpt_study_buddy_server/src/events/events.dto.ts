import { ApiProperty } from '@nestjs/swagger';
import { Event } from './event.model';
import { IsBoolean, IsDateString, IsNotEmpty } from 'class-validator';

export class EventDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  name: string;

  @ApiProperty()
  startTime: string;

  @ApiProperty()
  endTime: string;

  @ApiProperty()
  isAllDay: boolean;

  static fromDomain(domain: Event): EventDto {
    return {
      id: domain.id,
      name: domain.name,
      startTime: domain.startDate.toISOString(),
      endTime: domain.endDate.toISOString(),
      isAllDay: domain.isAllDay,
    };
  }
}

export class CreateEventRequest {
  @ApiProperty()
  @IsNotEmpty()
  name: string;

  @ApiProperty()
  @IsDateString()
  @IsNotEmpty()
  startTime: string;

  @ApiProperty()
  @IsDateString()
  @IsNotEmpty()
  endTime: string;

  @ApiProperty()
  @IsBoolean()
  @IsNotEmpty()
  isAllDay: boolean;
}
