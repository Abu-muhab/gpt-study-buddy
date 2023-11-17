import { Module } from '@nestjs/common';
import {
  BotMapper,
  BotsRepository,
  BotsRepositoryImpl,
} from './bots.repository';
import { BotsService } from './bots.service';
import { BotsController } from './bots.controller';
import { UsersModule } from 'src/users/users.module';
import { BotsGptFunctionHandler } from './bots_gpt_functions';

@Module({
  imports: [UsersModule],
  controllers: [BotsController],
  providers: [
    //repos
    {
      provide: BotsRepository,
      useClass: BotsRepositoryImpl,
    },

    //mappers
    BotMapper,

    //services
    BotsService,

    BotsGptFunctionHandler,
  ],
  exports: [BotsRepository, BotsGptFunctionHandler],
})
export class BotsModule {}
