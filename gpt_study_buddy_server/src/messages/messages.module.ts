import { Module } from '@nestjs/common';
import { MessagesGateway } from './messages.gateway';
import { GptService } from './gpt.service';
import { BotsModule } from 'src/bots/bots.module';

@Module({
  controllers: [],
  providers: [MessagesGateway, GptService],
  imports: [BotsModule],
})
export class MessagesModule {}
