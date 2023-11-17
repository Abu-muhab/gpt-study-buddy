import { Injectable } from '@nestjs/common';
import {
  CompletionCreatedResource,
  CompletionCreatedResourceType,
  GptFunction,
  GptFunctionHandler,
} from '../messages/gpt.model';
import { PptService } from './ppt.service';

@Injectable()
export class PptGptFunctionHanlder extends GptFunctionHandler {
  constructor(private readonly pptService: PptService) {
    super();
  }
  get handledFunctions(): GptFunction[] {
    return [
      {
        name: 'create_ppt',
        description:
          'This function creates a PowerPoint presentation for the user with the given user ID. To create a PowerPoint, all the contents of the slides must be provided in a single call. Making multiple calls to this function will result in the creation of multiple PowerPoint presentations.',
        parameters: {
          type: 'object',
          required: ['userId', 'title', 'slides', 'author', 'subject'],
          properties: {
            userId: {
              type: 'string',
              description: 'The user id of the user to create the ppt for.',
            },
            title: {
              type: 'string',
              description: 'The title of the ppt.',
            },
            author: {
              type: 'string',
              description: 'The author of the ppt.',
            },
            subject: {
              type: 'string',
              description: 'The subject of the ppt.',
            },
            slides: {
              type: 'array',
              items: {
                type: 'object',
                required: ['elements'],
                properties: {
                  elements: {
                    type: 'array',
                    items: {
                      type: 'object',
                      required: ['type', 'layoutOptions'],
                      properties: {
                        type: {
                          type: 'string',
                          enum: ['TEXT', 'IMAGE'],
                          description: 'The type of the element.',
                        },
                        text: {
                          type: 'string',
                          description:
                            'The value of the element if it is a text element.',
                        },
                        src: {
                          type: 'string',
                          description:
                            'The source of the element if it is an image element.',
                        },
                        layoutOptions: {
                          type: 'object',
                          description: 'The layout options of the element.',
                          required: ['x', 'y', 'w', 'h'],
                          properties: {
                            x: {
                              type: 'number',
                              description:
                                'The x position of the element (inches)',
                            },
                            y: {
                              type: 'number',
                              description:
                                'The y position of the element (inches)',
                            },
                            w: {
                              type: 'string',
                              description:
                                'The width of the element (percent) ',
                            },
                            h: {
                              type: 'string',
                              description:
                                'The height of the element (percent)',
                            },
                            fontSize: {
                              type: 'number',
                              description:
                                'The font size of the text element (points). This is optional',
                            },
                            bold: {
                              type: 'boolean',
                              description:
                                'Whether or not the text element is bold. This is optional',
                            },
                          },
                        },
                      },
                    },
                  },
                },
              },
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
      case 'create_ppt':
        const ppt = await this.pptService.createPresentation(args);
        return {
          result: JSON.stringify({
            message: 'PPT created successfully',
          }),
          createdResources: [
            {
              type: CompletionCreatedResourceType.ppt,
              resource: ppt,
            },
          ],
        };
      default:
        throw new Error('Function not implemented');
    }
  }
}
