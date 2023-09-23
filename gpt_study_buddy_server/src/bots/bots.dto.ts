import { ApiProperty } from '@nestjs/swagger';
import { Bot } from './bot.model';
import { IsNotEmpty } from 'class-validator';

export class BotDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  name: string;

  @ApiProperty()
  slug: string;

  @ApiProperty()
  description: string;

  static fromDomain(domain: Bot): BotDto {
    return {
      id: domain.id,
      name: domain.name,
      slug: domain.slug,
      description: domain.description,
    };
  }
}

export class CreateBotRequest {
  @ApiProperty()
  @IsNotEmpty()
  name: string;

  @ApiProperty()
  @IsNotEmpty()
  description: string;
}
