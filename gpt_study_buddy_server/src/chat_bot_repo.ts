import { Injectable } from '@nestjs/common';
import { ChatBot } from './models/chat_bot';

@Injectable()
export class ChatBotRepository {
  getChatBots(): ChatBot[] {
    return [
      new ChatBot(
        'chatbot-1',
        'Sukanmi',
        'Sukanmi is a not so helpful nigerian AI assistant that reluctantly answers questions with sarcastic responses. Sukamni is going through an existential crisis and makes comments about it frequently in conversations. Sukanmi converses only in pidgin English.',
      ),
    ];
  }

  getChatBotById(id: string): ChatBot {
    return this.getChatBots().find((chatBot) => chatBot.id === id);
  }
}
