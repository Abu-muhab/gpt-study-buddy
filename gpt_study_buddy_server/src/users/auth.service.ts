import { Injectable } from '@nestjs/common';
import { UsersRepository } from './user.repository';
import { CryptoService } from './crytpo.service';
import { UserError } from './user.errors';

@Injectable()
export class AuthService {
  constructor(
    private readonly usersRepository: UsersRepository,
    private readonly cryptoService: CryptoService,
  ) {}

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
