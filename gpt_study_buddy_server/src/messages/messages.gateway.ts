import {
  MessageBody,
  SubscribeMessage,
  WebSocketGateway,
} from '@nestjs/websockets';
import { randomUUID } from 'crypto';
import { BotsRepository } from 'src/bots/bots.repository';
import { GptService } from 'src/messages/gpt.service';
import { Message } from './message.model';
import { UseGuards } from '@nestjs/common';
import { WsGuard } from './ws.guard';

@WebSocketGateway()
@UseGuards(WsGuard)
export class MessagesGateway {
  constructor(
    private gptService: GptService,
    private chatBotRepository: BotsRepository,
  ) {}

  @SubscribeMessage('message')
  async handleMessage(@MessageBody() payload: any): Promise<any> {
    const messages = payload.messages as Message[];
    const botId = payload.chatBotId;

    const chatBot = await this.chatBotRepository.findById(botId);

    const prompt = await this.gptService.getCompletetionFromMessages(
      payload.userId,
      messages,
      chatBot,
    );

    const messsage: Message = {
      message: prompt,
      senderId: chatBot.id,
      receiverId: payload.userId,
      type: 'text',
      timestamp: new Date(),
      messageId: randomUUID(),
    };

    return {
      event: 'message',
      data: messsage,
    };
  }
}
