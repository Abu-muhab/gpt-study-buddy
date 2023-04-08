import { Injectable } from '@nestjs/common';
import axios from 'axios';
import { Message } from './models/message';

@Injectable()
export class GptService {
  private async getCompletion(prompt: string): Promise<string> {
    try {
      const response = await axios.post(
        'https://api.openai.com/v1/completions',
        {
          model: 'text-davinci-003',
          prompt: prompt,
          n: 1,
          stop: ['Human:', 'AI:'],
          max_tokens: 2048,
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
  ): Promise<string> {
    let prompt = '';
    messages.forEach((message) => {
      if (message.senderId === userId) {
        prompt += `Human: ${message.message}\n`;
      } else {
        prompt += `AI: ${message.message}\n`;
      }
    });
    prompt += 'AI: ';

    return await this.getCompletion(prompt);
  }
}
