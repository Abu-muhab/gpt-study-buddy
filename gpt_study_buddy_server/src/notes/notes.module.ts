import { Module } from '@nestjs/common';
import { NotesService } from './notes.service';
import { NotesController } from './notes.controller';
import {
  NotesMapper,
  NotesRepository,
  NotesRepositoryImpl,
} from './notes.repository';
import { NotesGptFunctionHanlder } from './notes_gpt_functions';

@Module({
  providers: [
    NotesService,
    {
      provide: NotesRepository,
      useClass: NotesRepositoryImpl,
    },
    NotesMapper,
    NotesGptFunctionHanlder,
  ],
  controllers: [NotesController],
  exports: [NotesService, NotesRepository, NotesGptFunctionHanlder],
})
export class NotesModule {}
