import { Injectable } from '@nestjs/common';
import {
  CompletionCreatedResource,
  GptFunction,
  GptFunctionHandler,
} from './gpt.model';
import { GptService } from './gpt.service';

export class InternalGptFunctionHandler extends GptFunctionHandler {
  constructor(private readonly gptService: GptService) {
    super();
  }

  get handledFunctions(): GptFunction[] {
    return [
      {
        name: 'generate_image',
        description:
          'Generates an image based on the given prompt. The image is returned as a URL. Note: Use this exclusively when you need images for powerpoint (ppt) creation.',
        parameters: {
          type: 'object',
          required: ['prompt'],
          properties: {
            prompt: {
              type: 'string',
              description: 'The prompt to generate the image from.',
            },
          },
        },
      },
      {
        name: 'get_current_date_time',
        description:
          'This function returns the current date and time in the ISO string format (e.g., 2021-06-13T15:00:00.000Z). Use it when you need to calculate future dates in reference to the current date and time.',
        parameters: {
          type: 'object',
          required: [],
          properties: {},
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
      case 'get_current_date_time':
        const date = new Date();
        return {
          result: date.toISOString(),
          createdResources: [],
        };
      case 'generate_image':
        const image = await this.gptService.generateImage(args.prompt);
        return {
          result: image,
          createdResources: [],
        };

      default:
        return {
          result: '',
          createdResources: [],
        };
    }
  }
}
