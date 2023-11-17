import { Module } from '@nestjs/common';
import { PptService } from './ppt.service';
import { BucketModule } from '../bucket/bucket.module';
import { PptGptFunctionHanlder } from './ppt_gpt_functions';

@Module({
  providers: [PptService, PptGptFunctionHanlder],
  exports: [PptService, PptGptFunctionHanlder],
  imports: [BucketModule],
})
export class PptModule {}
