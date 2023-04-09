import {
  MessageBody,
  SubscribeMessage,
  WebSocketGateway,
} from '@nestjs/websockets';
import { GptService } from './gpt.service';
import { Message } from './models/message';
import { randomUUID } from 'crypto';
import { ChatBotRepository } from './chat_bot_repo';

@WebSocketGateway(8000)
export class ChatGateway {
  constructor(
    private gptService: GptService,
    private chatBotRepository: ChatBotRepository,
  ) {}

  @SubscribeMessage('message')
  async handleMessage(@MessageBody() payload: any): Promise<any> {
    const messages = payload.messages as Message[];
    const botId = payload.chatBotId;

    const chatBot = this.chatBotRepository.getChatBotById(botId);

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
