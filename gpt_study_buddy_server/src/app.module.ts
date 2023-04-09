import { Module } from '@nestjs/common';
import { ChatGateway } from './chat.gateway';
import { GptService } from './gpt.service';
import { ConfigModule } from '@nestjs/config';
import { ChatBotRepository } from './chat_bot_repo';

@Module({
  imports: [ConfigModule.forRoot()],
  controllers: [],
  providers: [ChatGateway, GptService, ChatBotRepository],
})
export class AppModule {}
