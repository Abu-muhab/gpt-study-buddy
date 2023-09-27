import { Injectable } from '@nestjs/common';
import { NotesRepository } from './notes.repository';
import { Note } from './notes.model';

@Injectable()
export class NotesService {
  constructor(private readonly notesRepository: NotesRepository) {}

  async createNote(params: {
    title: string;
    content: string;
    userId: string;
  }): Promise<Note> {
    const note = new Note({
      id: await this.notesRepository.nextId(),
      title: params.title,
      content: params.content,
      lastUpdated: new Date().toISOString(),
      userId: params.userId,
    });
    await this.notesRepository.add(note);
    return note;
  }
}
