import { Module } from '@nestjs/common';
import { UsersService } from './users.service';
import {
  UserMappper,
  UsersRepository,
  UsersRepositoryImpl,
} from './user.repository';
import { CryptoService } from './crytpo.service';
import { UsersController } from './users.controller';

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
  ],
  controllers: [UsersController],
})
export class UsersModule {}
