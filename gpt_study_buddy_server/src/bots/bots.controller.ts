import { Body, Controller, Post, UseFilters } from '@nestjs/common';
import { HttpDomainExceptionFilter } from 'src/common/http_domain_exception_filter';
import { BotsService } from './bots.service';
import { BotDto, CreateBotRequest } from './bots.dto';
import { User } from 'src/users/user.model';
import { UserDecorator } from 'src/users/user.decorator';
import { ApiCreatedResponse, ApiOperation } from '@nestjs/swagger';

@Controller('bots')
@UseFilters(HttpDomainExceptionFilter)
export class BotsController {
  constructor(private readonly botsService: BotsService) {}

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
}
