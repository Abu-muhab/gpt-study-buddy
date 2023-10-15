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
  updatedAt: string;

  static fromDomain(domain: Note): NoteDto {
    return {
      id: domain.id,
      title: domain.title,
      content: domain.content,
      updatedAt: domain.updatedAt,
    };
  }
}

export class CreateNoteRequest {
  @ApiProperty()
  title: string;

  @ApiProperty()
  content: string;
}
