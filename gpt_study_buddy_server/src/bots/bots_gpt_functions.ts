import { Injectable } from '@nestjs/common';

import { BotsRepository } from './bots.repository';
import {
  GptFunctionHandler,
  GptFunction,
  CompletionCreatedResource,
} from '../messages/gpt.model';

@Injectable()
export class BotsGptFunctionHandler extends GptFunctionHandler {
  constructor(private readonly botsRepository: BotsRepository) {
    super();
  }

  get handledFunctions(): GptFunction[] {
    return [
      {
        name: 'get_user_bots',
        description:
          'Returns the bots that the user with the given user id has created.',
        parameters: {
          type: 'object',
          required: ['userId'],
          properties: {
            userId: {
              type: 'string',
              description: 'The user id of the user to get bots from.',
            },
          },
        },
      },
    ];
  }

  async handleFunction(params: {
    functionName: string;
    args: object;
  }): Promise<{
    result: string;
    createdResources: CompletionCreatedResource[];
  }> {
    const args = params.args as any;
    switch (params.functionName) {
      case 'get_user_bots':
        const bots = await this.botsRepository.getUserBots(args.userId);
        return {
          result: JSON.stringify(bots),
          createdResources: [],
        };
      default:
        throw new Error('Function not implemented');
    }
  }
}
