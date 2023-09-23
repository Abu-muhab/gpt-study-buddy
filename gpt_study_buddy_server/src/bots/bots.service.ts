import { Injectable } from '@nestjs/common';
import { BotsRepository } from './bots.repository';
import { Bot } from './bot.model';
import { UsersRepository } from 'src/users/user.repository';
import { UserError } from 'src/users/user.errors';
import { BotError } from './bots.errors';
import { StringHelper } from 'src/common/string_helpers';

@Injectable()
export class BotsService {
  constructor(
    private readonly botsRepository: BotsRepository,
    private readonly userRepository: UsersRepository,
  ) {}

  async createBot(params: {
    name: string;
    description: string;
    userId: string;
  }): Promise<Bot> {
    const user = await this.userRepository.findById(params.userId);
    if (!user) {
      throw new UserError.UserNotFound();
    }

    const botExists = await this.botsRepository.findBySlug({
      slug: StringHelper.slugify(params.name),
      userId: params.userId,
    });
    if (botExists) {
      throw new BotError.BotAlreadyExists();
    }

    const bot = new Bot({
      id: await this.botsRepository.nextId(),
      name: params.name,
      slug: StringHelper.slugify(params.name),
      description: params.description,
      userId: params.userId,
    });

    await this.botsRepository.add(bot);

    return bot;
  }
}
