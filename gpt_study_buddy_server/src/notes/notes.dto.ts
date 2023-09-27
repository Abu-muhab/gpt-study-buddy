import { ApiProperty } from '@nestjs/swagger';
import { Note } from './notes.model';

export class NoteDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  title: string;

  @ApiProperty()
  content: string;

  @ApiProperty()
  lastUpdated: string;

  static fromDomain(domain: Note): NoteDto {
    return {
      id: domain.id,
      title: domain.title,
      content: domain.content,
      lastUpdated: domain.lastUpdated,
    };
  }
}

export class CreateNoteRequest {
  @ApiProperty()
  title: string;

  @ApiProperty()
  content: string;
}
