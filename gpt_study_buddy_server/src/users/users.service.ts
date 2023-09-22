import { Injectable } from '@nestjs/common';
import { User } from './user.model';
import { UsersRepository } from './user.repository';
import { CryptoService } from './crytpo.service';
import { UserError } from './user.errors';

@Injectable()
export class UsersService {
  constructor(
    private readonly usersRepository: UsersRepository,
    private readonly cryptoService: CryptoService,
  ) {}

  async createUser(request: {
    firstName: string;
    lastName: string;
    email: string;
    password: string;
  }): Promise<User> {
    const newUser = new User({
      id: await this.usersRepository.nextId(),
      firstName: request.firstName,
      lastName: request.lastName,
      email: request.email,
      password: await this.cryptoService.hasPassword(request.password),
    });

    const userExists = await this.usersRepository.findByEmail(newUser.email);
    if (userExists) {
      throw new UserError.UserAlreadyExists();
    }

    await this.usersRepository.add(newUser);

    return newUser;
  }
}
