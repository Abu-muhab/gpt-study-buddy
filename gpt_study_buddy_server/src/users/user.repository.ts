import { Repository } from 'src/common/repository';
import { User } from './user.model';
import { MongoDbRepository } from 'src/common/mongodb_repository';
import { Schema, model } from 'mongoose';
import { Mapper } from 'src/common/mapper';
import { Injectable } from '@nestjs/common';

export abstract class UsersRepository extends Repository<User> {
  abstract findByEmail(email: string): Promise<User>;
}

export interface UserDocument {
  id: string;
  firstName: string;
  lastName: string;
  email: string;
  password: string;
}

const userSchema = new Schema<UserDocument>({
  id: { type: String, required: true },
  firstName: { type: String, required: true },
  lastName: { type: String, required: true },
  email: { type: String, required: true },
  password: { type: String, required: true },
});

@Injectable()
export class UserMappper extends Mapper<User, UserDocument> {
  toPersistence(entity: User): UserDocument {
    if (!entity) return null;
    return {
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      password: entity.password,
    };
  }
  toDomain(document: UserDocument): User {
    if (!document) return null;
    return new User({
      id: document.id,
      firstName: document.firstName,
      lastName: document.lastName,
      email: document.email,
      password: document.password,
    });
  }
}

const UserModel = model<UserDocument>('User', userSchema);

@Injectable()
export class UsersRepositoryImpl
  extends MongoDbRepository<User, UserDocument>
  implements UsersRepository
{
  constructor(mapper: UserMappper) {
    super(UserModel, mapper);
  }
  async findByEmail(email: string): Promise<User> {
    const userDoc = await this.model.findOne({ email: email });
    if (!userDoc) {
      return null;
    }

    const user = this.mapper.toDomain(userDoc);
    return user;
  }
}
