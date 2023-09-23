import { Module } from '@nestjs/common';
import {
  BotMapper,
  BotsRepository,
  BotsRepositoryImpl,
} from './bots.repository';
import { BotsService } from './bots.service';
import { BotsController } from './bots.controller';
import { UsersModule } from 'src/users/users.module';

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
  ],
  exports: [BotsRepository],
})
export class BotsModule {}
