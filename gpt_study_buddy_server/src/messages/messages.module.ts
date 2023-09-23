import { Module } from '@nestjs/common';
import { MessagesGateway } from './messages.gateway';
import { GptService } from './gpt.service';
import { BotsModule } from 'src/bots/bots.module';
import { UsersModule } from 'src/users/users.module';

@Module({
  controllers: [],
  providers: [MessagesGateway, GptService],
  imports: [BotsModule, UsersModule],
})
export class MessagesModule {}
