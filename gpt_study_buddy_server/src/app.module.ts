import { Module } from '@nestjs/common';
import { ChatGateway } from './chat.gateway';

@Module({
  imports: [],
  controllers: [],
  providers: [ChatGateway],
})
export class AppModule {}
