import { Module } from '@nestjs/common';
import { PptService } from './ppt.service';
import { BucketModule } from '../bucket/bucket.module';

@Module({
  providers: [PptService],
  exports: [PptService],
  imports: [BucketModule],
})
export class PptModule {}
