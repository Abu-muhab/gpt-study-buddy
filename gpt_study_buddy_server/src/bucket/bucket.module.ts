import { Module } from '@nestjs/common';
import { BucketService } from './bucket.service';

@Module({
  providers: [BucketService],
  exports: [BucketService],
})
export class BucketModule {}
