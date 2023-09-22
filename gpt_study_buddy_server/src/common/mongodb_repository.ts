import { Model } from 'mongoose';
import { Mapper } from './mapper';
import { Entity, Repository } from './repository';
import { randomUUID } from 'crypto';

export abstract class MongoDbRepository<E extends Entity, D>
  implements Repository<E>
{
  model: Model<D>;
  mapper: Mapper<E, D>;

  constructor(model: Model<D>, mapper: Mapper<E, D>) {
    this.model = model;
    this.mapper = mapper;
  }

  add(entity: E): Promise<void> {
    return new Promise<void>(async (resolve, reject) => {
      try {
        const newModel = new this.model(this.mapper.toPersistence(entity));
        await newModel.save();
        resolve();
      } catch (err) {
        reject(err);
      }
    });
  }

  async update(entity: E): Promise<void> {
    const model = await this.model.findOneAndUpdate(
      { id: entity.id },
      this.mapper.toPersistence(entity),
    );
    if (!model) {
      throw new Error('Entity not found');
    }
  }

  async delete(entity: E): Promise<void> {
    const model = await this.model.findOneAndDelete({ id: entity.id });
    if (!model) {
      throw new Error('Entity not found');
    }
  }

  async findById(id: String): Promise<E> {
    const model = await this.model.findOne({ id: id });
    if (!model) {
      return null;
    }
    const entity = this.mapper.toDomain(model);
    return entity;
  }

  async nextId(): Promise<string> {
    return randomUUID();
  }
}
