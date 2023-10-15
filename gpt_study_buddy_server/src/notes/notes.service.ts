import { Injectable } from '@nestjs/common';
import { NotesRepository } from './notes.repository';
import { Note } from './notes.model';
import { DomainError, DomainErrorType } from '../common/domain_error';

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
      updatedAt: new Date().toISOString(),
      userId: params.userId,
    });
    await this.notesRepository.add(note);
    return note;
  }

  async updateNote(params: {
    id: string;
    title: string;
    content: string;
    userId: string;
  }): Promise<Note> {
    const note = await this.notesRepository.findById(params.id);
    if (!note) {
      throw new DomainError(DomainErrorType.NotFound, 'Note not found');
    }

    if (note.userId !== params.userId) {
      throw new DomainError(
        DomainErrorType.Forbidden,
        'Note does not belong to user',
      );
    }

    note.title = params.title;
    note.content = params.content;
    note.updatedAt = new Date().toISOString();

    await this.notesRepository.update(note);

    return note;
  }

  async deleteNote(params: { id: string; userId: string }): Promise<void> {
    const note = await this.notesRepository.findById(params.id);
    if (!note) {
      throw new DomainError(DomainErrorType.NotFound, 'Note not found');
    }

    if (note.userId !== params.userId) {
      throw new DomainError(
        DomainErrorType.Forbidden,
        'Note does not belong to user',
      );
    }

    await this.notesRepository.delete(note);
  }
}
