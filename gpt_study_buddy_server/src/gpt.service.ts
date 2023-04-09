import { Injectable } from '@nestjs/common';
import axios from 'axios';
import { Message } from './models/message';
import { ChatBotRepository } from './chat_bot_repo';
import { ChatBot } from './models/chat_bot';

@Injectable()
export class GptService {
  private async getCompletion(
    prompt: string,
    chatBot: ChatBot,
  ): Promise<string> {
    try {
      const response = await axios.post(
        'https://api.openai.com/v1/completions',
        {
          model: 'text-davinci-003',
          prompt: prompt,
          n: 1,
          stop: ['Human:', `${chatBot.name}:`],
          max_tokens: 2048,
          temperature: 1,
          presence_penalty: 1,
          frequency_penalty: 1,
        },
        {
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${process.env.OPENAI_API_KEY}`,
          },
        },
      );
      return response.data.choices[0].text;
    } catch (e) {
      console.log(e);
    }
  }

  async getCompletetionFromMessages(
    userId: string,
    messages: Message[],
    chatBot: ChatBot,
  ): Promise<string> {
    let prompt = chatBot.description + '\n';
    messages.forEach((message) => {
      if (message.senderId === userId) {
        prompt += `Human: ${message.message}\n`;
      } else {
        prompt += `${chatBot.name}: ${message.message}\n`;
      }
    });
    prompt += `${chatBot.name}: `;

    return await this.getCompletion(prompt, chatBot);
  }
}
