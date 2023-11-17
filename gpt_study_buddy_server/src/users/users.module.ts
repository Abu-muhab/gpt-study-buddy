import { Module } from '@nestjs/common';
import { UsersService } from './users.service';
import {
  UserMappper,
  UsersRepository,
  UsersRepositoryImpl,
} from './user.repository';
import { CryptoService } from './crytpo.service';
import { UsersController } from './users.controller';
import { UsersGptFunctionHandler } from './users_gpt_functions';

@Module({
  providers: [
    //services
    UsersService,
    CryptoService,

    //repositories
    {
      provide: UsersRepository,
      useClass: UsersRepositoryImpl,
    },

    //mappers
    UserMappper,

    UsersGptFunctionHandler,
  ],
  controllers: [UsersController],
  exports: [
    UsersRepository,
    CryptoService,
    UsersService,
    UsersGptFunctionHandler,
  ],
})
export class UsersModule {}
