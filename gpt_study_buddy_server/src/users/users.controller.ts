import { Body, Controller, Post, UseFilters } from '@nestjs/common';
import { UsersService } from './users.service';
import {
  AuthResponse,
  CreateUserRequest,
  LoginRequest,
  UserDto,
} from './user.dto';
import { ApiCreatedResponse, ApiOperation } from '@nestjs/swagger';
import { HttpDomainExceptionFilter } from 'src/common/http_domain_exception_filter';
import { UsersRepository } from './user.repository';
import { TrimPipe } from './auth.middleware';

@Controller('users')
@UseFilters(HttpDomainExceptionFilter)
export class UsersController {
  constructor(
    private readonly usersService: UsersService,
    private readonly usersRepository: UsersRepository,
  ) {}

  @Post()
  @ApiCreatedResponse({ type: AuthResponse })
  @ApiOperation({ summary: 'Create a new user' })
  async createUser(@Body() body: CreateUserRequest): Promise<AuthResponse> {
    const userDto = UserDto.fromDomain(
      await this.usersService.createUser(body),
    );

    const token = await this.usersService.login({
      email: body.email,
      password: body.password,
    });

    return {
      token,
      user: userDto,
    };
  }

  @Post('login')
  @ApiCreatedResponse({ type: AuthResponse })
  @ApiOperation({ summary: 'Login' })
  async login(@Body() body: LoginRequest): Promise<AuthResponse> {
    return {
      token: await this.usersService.login({
        email: body.email,
        password: body.password,
      }),
      user: UserDto.fromDomain(
        await this.usersRepository.findByEmail(body.email),
      ),
    };
  }
}
