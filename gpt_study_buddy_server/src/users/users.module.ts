import { Module } from '@nestjs/common';
import { UsersService } from './users.service';
import {
  UserMappper,
  UsersRepository,
  UsersRepositoryImpl,
} from './user.repository';
import { CryptoService } from './crytpo.service';
import { UsersController } from './users.controller';
import { AuthService } from './auth.service';

@Module({
  providers: [
    //services
    UsersService,
    CryptoService,
    AuthService,

    //repositories
    {
      provide: UsersRepository,
      useClass: UsersRepositoryImpl,
    },

    //mappers
    UserMappper,
  ],
  controllers: [UsersController],
  exports: [UsersRepository, CryptoService],
})
export class UsersModule {}
