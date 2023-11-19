import { Module } from '@nestjs/common';
import { BucketService } from './bucket.service';
import {
  BucketFileMapper,
  BucketFileRepository,
  BucketFileRepositoryImpl,
} from './bucket.repository';

@Module({
  providers: [
    BucketService,
    BucketFileMapper,
    {
      provide: BucketFileRepository,
      useClass: BucketFileRepositoryImpl,
    },
  ],
  exports: [BucketService],
})
export class BucketModule {}
