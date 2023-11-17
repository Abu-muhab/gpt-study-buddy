import { Injectable } from '@nestjs/common';

import { UsersRepository } from './user.repository';
import {
  GptFunctionHandler,
  GptFunction,
  CompletionCreatedResource,
} from '../messages/gpt.model';

@Injectable()
export class UsersGptFunctionHandler extends GptFunctionHandler {
  constructor(private readonly usersRepository: UsersRepository) {
    super();
  }

  get handledFunctions(): GptFunction[] {
    return [
      {
        name: 'get_user_information',
        description:
          'Returns information about the user such as the firstName, lastName and email.',
        parameters: {
          type: 'object',
          required: ['userId'],
          properties: {
            userId: {
              type: 'string',
              description: 'The user id of the user to get information from.',
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
      case 'get_user_information':
        const response = await this.usersRepository.findById(args.userId);
        return {
          result: JSON.stringify(response),
          createdResources: [],
        };
      case 'get_user_information':
      default:
        throw new Error('Function not implemented');
    }
  }
}
