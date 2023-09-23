import { Bot } from './bot.model';
import { Repository } from 'src/common/repository';
import { MongoDbRepository } from 'src/common/mongodb_repository';
import { Schema, model } from 'mongoose';
import { Injectable } from '@nestjs/common';
import { Mapper } from 'src/common/mapper';

export abstract class BotsRepository extends Repository<Bot> {
  abstract getUserBots(userId: string): Promise<Bot[]>;
  abstract findBySlug(slug: string, userId: string): Promise<Bot>;
}

export interface BotDocument {
  id: string;
  name: string;
  slug: string;
  description: string;
  userId: string;
}

const botSchema = new Schema<BotDocument>({
  id: { type: String, required: true },
  name: { type: String, required: true },
  description: { type: String, required: true },
  userId: { type: String, required: true },
});

@Injectable()
export class BotMapper extends Mapper<Bot, BotDocument> {
  toPersistence(entity: Bot): BotDocument {
    if (!entity) return null;
    return {
      id: entity.id,
      name: entity.name,
      slug: entity.slug,
      description: entity.description,
      userId: entity.userId,
    };
  }
  toDomain(document: BotDocument): Bot {
    if (!document) return null;
    return new Bot({
      id: document.id,
      name: document.name,
      slug: document.slug,
      description: document.description,
      userId: document.userId,
    });
  }
}

const BotModel = model<BotDocument>('Bot', botSchema);

@Injectable()
export class BotsRepositoryImpl
  extends MongoDbRepository<Bot, BotDocument>
  implements BotsRepository
{
  constructor(mapper: BotMapper) {
    super(BotModel, mapper);
  }

  async findBySlug(slug: string, userId: string): Promise<Bot> {
    const document = await this.model.findOne({ slug: slug, userId: userId });
    return this.mapper.toDomain(document);
  }

  async getUserBots(userId: string): Promise<Bot[]> {
    const documents = await this.model.find({ userId: userId });
    return documents.map((document) => this.mapper.toDomain(document));
  }
}
