import { Schema, model } from 'mongoose';
import { Repository } from '../common/repository';
import { BucketFile } from './bucket_file.model';
import { Injectable } from '@nestjs/common';
import { Mapper } from '../common/mapper';
import { MongoDbRepository } from '../common/mongodb_repository';

export abstract class BucketFileRepository extends Repository<BucketFile> {
  abstract findByUserId(userId: string): Promise<BucketFile[]>;
}

export interface BucketFileDocument {
  id: string;
  userId: string;
  name: string;
  folder: string;
  type: string;
  url: string;
}

const bucketFileSchema = new Schema<BucketFileDocument>({
  id: String,
  userId: String,
  name: String,
  folder: String,
  type: String,
  url: String,
});

@Injectable()
export class BucketFileMapper extends Mapper<BucketFile, BucketFileDocument> {
  toPersistence(entity: BucketFile): BucketFileDocument {
    if (!entity) return null;
    return {
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      folder: entity.folder,
      type: entity.type,
      url: entity.url,
    };
  }
  toDomain(document: BucketFileDocument): BucketFile {
    if (!document) return null;
    return new BucketFile({
      id: document.id,
      userId: document.userId,
      name: document.name,
      folder: document.folder,
      type: document.type,
      url: document.url,
    });
  }
}

const BucketFileModel = model<BucketFileDocument>(
  'BucketFile',
  bucketFileSchema,
);

@Injectable()
export class BucketFileRepositoryImpl
  extends MongoDbRepository<BucketFile, BucketFileDocument>
  implements BucketFileRepository
{
  constructor(mapper: BucketFileMapper) {
    super(BucketFileModel, mapper);
  }

  async findByUserId(userId: string): Promise<BucketFile[]> {
    const bucketFiles = await this.model.find({ userId: userId });
    return bucketFiles.map((bucketFile) => this.mapper.toDomain(bucketFile));
  }
}
