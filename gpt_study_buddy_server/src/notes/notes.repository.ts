import { Schema, model } from 'mongoose';
import { Repository } from '../common/repository';
import { Note } from './notes.model';
import { Injectable } from '@nestjs/common';
import { Mapper } from '../common/mapper';
import { MongoDbRepository } from '../common/mongodb_repository';

export abstract class NotesRepository extends Repository<Note> {
  abstract getUserNotes(userId: string): Promise<Note[]>;
}

export interface NoteDocument {
  id: string;
  title: string;
  content: string;
  lastUpdated: string;
  userId: string;
}

const noteSchema = new Schema<NoteDocument>({
  id: { type: String, required: true },
  title: { type: String, required: false },
  content: { type: String, required: true },
  lastUpdated: { type: String, required: true },
  userId: { type: String, required: true },
});

const NoteModel = model<NoteDocument>('Note', noteSchema);

@Injectable()
export class NotesMapper extends Mapper<Note, NoteDocument> {
  toPersistence(entity: Note): NoteDocument {
    if (!entity) return null;
    return {
      id: entity.id,
      title: entity.title,
      content: entity.content,
      lastUpdated: entity.lastUpdated,
      userId: entity.userId,
    };
  }
  toDomain(document: NoteDocument): Note {
    if (!document) return null;
    return new Note({
      id: document.id,
      title: document.title,
      content: document.content,
      lastUpdated: document.lastUpdated,
      userId: document.userId,
    });
  }
}

@Injectable()
export class NotesRepositoryImpl
  extends MongoDbRepository<Note, NoteDocument>
  implements NotesRepository
{
  constructor(mapper: NotesMapper) {
    super(NoteModel, mapper);
  }
  async getUserNotes(userId: string): Promise<Note[]> {
    const documents = await NoteModel.find({ userId });
    return documents.map((d) => this.mapper.toDomain(d));
  }
}
