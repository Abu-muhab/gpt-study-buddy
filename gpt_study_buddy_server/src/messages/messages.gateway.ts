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

    const completionResult = await this.gptService.getCompletetionFromMessages(
      payload.userId,
      messages,
      chatBot,
    );

    if (!completionResult.completion) {
      return {
        event: 'message',
        data: {
          message:
            'Sorry, i encountered an error processing your request. can you try again?',
          senderId: chatBot.id,
          receiverId: payload.userId,
          type: 'text',
          timestamp: new Date(),
          messageId: randomUUID(),
        },
      };
    }

    const messsage: Message = {
      message: completionResult.completion,
      senderId: chatBot.id,
      receiverId: payload.userId,
      type: 'text',
      timestamp: new Date(),
      messageId: randomUUID(),
      createdResources: completionResult.createdResources,
    };

    return {
      event: 'message',
      data: messsage,
    };
  }
}
