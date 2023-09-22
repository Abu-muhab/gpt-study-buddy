import { Body, Controller, Post, UseFilters } from '@nestjs/common';
import { UsersService } from './users.service';
import { CreateUserRequest, UserDto } from './user.dto';
import { ApiCreatedResponse, ApiOperation } from '@nestjs/swagger';
import { HttpDomainExceptionFilter } from 'src/common/http_domain_exception_filter';

@Controller('users')
@UseFilters(HttpDomainExceptionFilter)
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Post()
  @ApiCreatedResponse({ type: UserDto })
  @ApiOperation({ summary: 'Create a new user' })
  async createUser(@Body() body: CreateUserRequest): Promise<UserDto> {
    return UserDto.fromDomain(await this.usersService.createUser(body));
  }
}
