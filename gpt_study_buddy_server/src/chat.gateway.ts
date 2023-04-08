import {
  MessageBody,
  SubscribeMessage,
  WebSocketGateway,
} from '@nestjs/websockets';
import { GptService } from './gpt.service';
import { Message } from './models/message';
import { randomUUID } from 'crypto';

@WebSocketGateway(8000)
export class ChatGateway {
  constructor(private gptService: GptService) {}

  @SubscribeMessage('message')
  async handleMessage(@MessageBody() payload: any): Promise<any> {
    const messages = payload.messages as Message[];
    const prompt = await this.gptService.getCompletetionFromMessages(
      payload.userId,
      messages,
    );

    const messsage: Message = {
      message: prompt,
      senderId: 'AI',
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
