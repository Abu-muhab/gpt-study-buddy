import { Module } from '@nestjs/common';
import { ChatGateway } from './chat.gateway';
import { GptService } from './gpt.service';
import { ConfigModule } from '@nestjs/config';

@Module({
  imports: [ConfigModule.forRoot()],
  controllers: [],
  providers: [ChatGateway, GptService],
})
export class AppModule {}
