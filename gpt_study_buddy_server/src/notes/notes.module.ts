import { Module } from '@nestjs/common';
import { NotesService } from './notes.service';
import { NotesController } from './notes.controller';
import {
  NotesMapper,
  NotesRepository,
  NotesRepositoryImpl,
} from './notes.repository';

@Module({
  providers: [
    NotesService,
    {
      provide: NotesRepository,
      useClass: NotesRepositoryImpl,
    },
    NotesMapper,
  ],
  controllers: [NotesController],
})
export class NotesModule {}
