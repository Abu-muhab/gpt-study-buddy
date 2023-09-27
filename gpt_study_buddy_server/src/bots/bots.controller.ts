import { Body, Controller, Get, Post, UseFilters } from '@nestjs/common';
import { HttpDomainExceptionFilter } from 'src/common/http_domain_exception_filter';
import { BotsService } from './bots.service';
import { BotDto, CreateBotRequest } from './bots.dto';
import { User } from 'src/users/user.model';
import { UserDecorator } from 'src/users/user.decorator';
import { ApiCreatedResponse, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { BotsRepository } from './bots.repository';

@Controller('bots')
@UseFilters(HttpDomainExceptionFilter)
export class BotsController {
  constructor(
    private readonly botsService: BotsService,
    private readonly botsRepository: BotsRepository,
  ) {}

  @Post()
  @ApiCreatedResponse({ type: BotDto })
  @ApiOperation({ summary: 'Create a new bot' })
  async createBot(
    @UserDecorator() user: User,
    @Body() body: CreateBotRequest,
  ): Promise<BotDto> {
    return BotDto.fromDomain(
      await this.botsService.createBot({
        name: body.name,
        description: body.description,
        userId: user.id,
      }),
    );
  }

  @Get()
  @ApiOperation({ summary: 'Get all bots for a user' })
  @ApiResponse({ type: [BotDto], status: 200 })
  async getUserBots(@UserDecorator() user: User): Promise<BotDto[]> {
    const bots = await this.botsRepository.getUserBots(user.id);
    return bots.map((bot) => BotDto.fromDomain(bot));
  }
}
