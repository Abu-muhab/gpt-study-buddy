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

  public async login(params: {
    email: string;
    password: string;
  }): Promise<string> {
    const user = await this.usersRepository.findByEmail(params.email);
    if (!user) {
      throw new UserError.InvalidCredentials();
    }

    const isPasswordValid = await this.cryptoService.comparePassword(
      params.password,
      user.password,
    );
    if (!isPasswordValid) {
      throw new UserError.InvalidCredentials();
    }

    const authToken = await this.cryptoService.generateAccessToken({
      id: user.id,
    });

    return authToken;
  }
}
