import { Body, Controller, Get, Post, UseFilters } from '@nestjs/common';
import { NotesService } from './notes.service';
import { ApiCreatedResponse, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { CreateNoteRequest, NoteDto } from './notes.dto';
import { UserDecorator } from '../users/user.decorator';
import { User } from '../users/user.model';
import { NotesRepository } from './notes.repository';
import { HttpDomainExceptionFilter } from '../common/http_domain_exception_filter';

@Controller('notes')
@UseFilters(HttpDomainExceptionFilter)
export class NotesController {
  constructor(
    private readonly notesService: NotesService,
    private readonly notesRepository: NotesRepository,
  ) {}

  @Post()
  @ApiOperation({ summary: 'Create a new note' })
  @ApiCreatedResponse({
    description: 'The note has been successfully created.',
    type: NoteDto,
  })
  async createNote(
    @UserDecorator() user: User,
    @Body() body: CreateNoteRequest,
  ): Promise<NoteDto> {
    const note = await this.notesService.createNote({
      title: body.title,
      content: body.content,
      userId: user.id,
    });

    return NoteDto.fromDomain(note);
  }

  @Get()
  @ApiOperation({ summary: 'Get all notes for the current user' })
  @ApiResponse({ type: [NoteDto], status: 200 })
  async getUserNotes(@UserDecorator() user: User): Promise<NoteDto[]> {
    const notes = await this.notesRepository.getUserNotes(user.id);
    return notes.map((note) => NoteDto.fromDomain(note));
  }
}
