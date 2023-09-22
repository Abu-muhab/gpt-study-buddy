import { Module } from '@nestjs/common';
import { ChatGateway } from './chat.gateway';
import { GptService } from './gpt.service';
import { ConfigModule } from '@nestjs/config';
import { ChatBotRepository } from './chat_bot_repo';
import { UsersModule } from './users/users.module';

@Module({
  imports: [ConfigModule.forRoot(), UsersModule],
  controllers: [],
  providers: [ChatGateway, GptService, ChatBotRepository],
})
export class AppModule {}
