import { Injectable } from '@nestjs/common';
import {
  CompletionCreatedResource,
  CompletionCreatedResourceType,
  GptFunction,
  GptFunctionHandler,
} from '../messages/gpt.model';
import { NotesService } from './notes.service';
import { NoteDto } from './notes.dto';
import { NotesRepository } from './notes.repository';

@Injectable()
export class NotesGptFunctionHanlder extends GptFunctionHandler {
  constructor(
    private readonly notesService: NotesService,
    private readonly notesRepository: NotesRepository,
  ) {
    super();
  }
  get handledFunctions(): GptFunction[] {
    return [
      {
        name: 'get_user_notes',
        description:
          'Returns notes that the user with the given user id has created. Can include notes such as learning notes, meeting notes, etc.',
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
      {
        name: 'create_note',
        description:
          'Create a note for the user with the given user ID and add it to the user notes. Use this only when you need to add a single note.',
        parameters: {
          type: 'object',
          required: ['userId', 'title', 'content'],
          properties: {
            userId: {
              type: 'string',
              description: 'The user id of the user to create the note for.',
            },
            title: {
              type: 'string',
              description: 'The title of the note.',
            },
            content: {
              type: 'string',
              description: 'The content of the note.',
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
      case 'create_note':
        const note = await this.notesService.createNote({
          title: args.title,
          content: args.content,
          userId: args.userId,
        });
        return {
          result: JSON.stringify(note),
          createdResources: [
            {
              type: CompletionCreatedResourceType.note,
              resource: NoteDto.fromDomain(note),
            },
          ],
        };
      case 'get_user_notes':
        const notes = await this.notesRepository.getUserNotes(args.userId);
        return {
          result: JSON.stringify(notes),
          createdResources: [],
        };
      default:
        throw new Error('Function not implemented');
    }
  }
}
