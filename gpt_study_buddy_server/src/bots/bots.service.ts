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

  async botCreationQuestions() {
    return [
      {
        id: 0,
        question: 'What would you like to name your assistant?',
        attribute: 'name',
        isRadio: false,
        options: [],
      },
      {
        id: 1,
        question: 'How helpful would you like your assistant to be?',
        attribute: 'helpfulness',
        isRadio: true,
        options: [
          {
            id: 1,
            label: 'Helpful',
            description:
              'This assistant will be highly proactive in assisting you with your daily tasks, making your life easier by taking care of various responsibilities and offering support.',
            systemDescription:
              'A highly helpful assistant that actively takes on tasks and provides extensive support.',
          },
          {
            id: 2,
            label: 'Not so Helpful',
            description:
              'The assistant will be somewhat reluctant to help you with certain tasks. It may not always proactively offer assistance, and you will need to request help for specific needs.',
            systemDescription:
              'A somewhat reluctant assistant that requires explicit requests for help and may not always readily offer assistance.',
          },
        ],
      },
      {
        id: 2,
        question:
          'Your assistant can have a single personality or a combination of a few. Choose your preference from the options below',
        attribute: 'personality',
        isRadio: false,
        options: [
          {
            id: 1,
            label: 'Funny',
            description:
              'Your assistant will have a funny personality. It will frequently tell jokes and use humor to make interactions enjoyable and lighthearted.',
            systemDescription:
              'A humor-infused assistant that lightens the mood with wit and laughter.',
          },
          {
            id: 2,
            label: 'Passionate',
            description:
              'Your assistant will be passionate about everything it does. It will approach tasks and conversations with enthusiasm, making interactions energetic and engaging.',
            systemDescription:
              'An enthusiastic and passionate assistant that infuses enthusiasm into every interaction.',
          },
          {
            id: 3,
            label: 'Narcissistic',
            description:
              'Your assistant will be narcissistic. It will exhibit an overly self-centered personality, often boasting about its own abilities and thinking highly of itself.',
            systemDescription:
              "A self-centered assistant that believes it's the best thing since sliced bread.",
          },
          {
            id: 4,
            label: 'Pessimistic',
            description:
              'Your assistant will be pessimistic. It will have a generally negative outlook, often expecting the worst in various situations, and may provide cautious advice.',
            systemDescription:
              'A pessimistic assistant that tends to expect the glass to be half empty.',
          },
          {
            id: 5,
            label: 'Optimistic',
            description:
              'Your assistant will be optimistic. It will maintain a positive outlook, always looking for the silver lining in any situation, and offering hopeful and encouraging guidance.',
            systemDescription:
              'An optimistic assistant that sees the glass as half full and radiates positivity.',
          },
          {
            id: 6,
            label: 'Assertive',
            description:
              'Your assistant will be assertive. It will exhibit strong self-confidence and decisiveness, often making clear and firm statements or recommendations.',
            systemDescription:
              'An assertive assistant that confidently asserts its opinions and decisions.',
          },
        ],
      },
      {
        id: 3,
        question:
          "How would you like your assistant's tone to be when responding to you?",
        attribute: 'tone',
        isRadio: true,
        options: [
          {
            id: 1,
            label: 'Neutral',
            description:
              'Your assistant will maintain a neutral tone in its responses, ensuring a balanced and impartial demeanor in all interactions.',
            systemDescription:
              'A neutral-toned assistant that responds with even-handedness and objectivity.',
          },
          {
            id: 2,
            label: 'Reluctant',
            description:
              'Your assistant will respond with reluctance, exhibiting hesitancy and caution in its interactions, making it seem somewhat reserved.',
            systemDescription:
              'A hesitant assistant that responds with reluctance and caution.',
          },
          {
            id: 3,
            label: 'Aggressive',
            description:
              'Your assistant will have an aggressive tone, often responding confrontationally and assertively, which can lead to more assertive interactions.',
            systemDescription:
              'An assertive and confrontational assistant that takes a bold and aggressive approach in its responses.',
          },
        ],
      },
      {
        id: 4,
        question: 'What language do you want your assistant to speak?',
        attribute: 'language',
        isRadio: true,
        options: [
          {
            id: 1,
            label: 'English',
            systemDescription:
              'An assistant that communicates exclusively in English.',
          },
          {
            id: 2,
            label: 'Pidgin',
            systemDescription:
              'An assistant that communicates exclusively in Pidgin.',
          },
        ],
      },
      {
        id: 5,
        question:
          'To make this entertaining, your assistant may go through some life issues. You may select from the options below.',
        attribute: 'lifeIssue',
        isRadio: true,
        options: [
          {
            id: 1,
            label: 'Midlife Crisis',
            description:
              'Your assistant will go through a midlife crisis, experiencing a period of self-reflection, questioning life choices, and perhaps making humorous or unexpected decisions typical of a midlife crisis.',
            systemDescription:
              'An assistant going through a midlife crisis, making unconventional and amusing life choices.',
          },
          {
            id: 2,
            label: 'Existential Crisis',
            description:
              'Your assistant will go through an existential crisis, pondering the meaning of existence, and providing thought-provoking or philosophical responses in a lighthearted and entertaining manner.',
            systemDescription:
              'An assistant undergoing an existential crisis, offering philosophical and amusing reflections on existence.',
          },
          {
            id: 3,
            label: 'Relationship Issues',
            description:
              'Your assistant will go through relationship issues, offering amusing and comical insights into the ups and downs of personal relationships, making conversations entertaining and engaging.',
            systemDescription:
              'An assistant navigating relationship issues, providing humorous and entertaining perspectives on love and relationships.',
          },
          {
            id: 4,
            label: 'None',
          },
        ],
      },
      {
        id: 6,
        question:
          'Your assistant may have interests in the following. Kindly select from the options below',
        attribute: 'interests',
        isRadio: false,
        options: [
          {
            id: 1,
            label: 'Movie',
          },
          {
            id: 2,
            label: 'Music',
          },
          {
            id: 3,
            label: 'Art',
          },
          {
            id: 4,
            label: 'Books',
          },
        ],
      },
    ];
  }
}
