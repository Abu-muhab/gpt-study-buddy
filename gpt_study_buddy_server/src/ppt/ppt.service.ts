import { Injectable } from '@nestjs/common';
import pptxgen from 'pptxgenjs';
import { ImageElement, Ppt, SlideElementType, TextElement } from './ppt.model';
import {
  BucketService,
  FileType,
  ResourceFolder,
} from '../bucket/bucket.service';

@Injectable()
export class PptService {
  constructor(private readonly bucketService: BucketService) {}

  async createPresentation(args): Promise<string> {
    let presentation = new pptxgen();
    presentation.author = args.author ?? '';
    presentation.subject = args.subject ?? '';
    presentation.title = args.title ?? '';

    for (const slide of args.slides) {
      let pptSlide = presentation.addSlide();

      for (const element of slide.elements) {
        switch (SlideElementType.fromString(element.type)) {
          case SlideElementType.TEXT:
            const textElement = element as TextElement;
            pptSlide = await this.addText(
              pptSlide,
              textElement.text,
              element.layoutOptions,
            );
            break;
          case SlideElementType.IMAGE:
            const imageElement = element as ImageElement;
            pptSlide = await this.addImage(pptSlide, imageElement.src);
            break;
        }
      }
    }

    const arrayBuffer = await presentation.stream();
    const url = await this.bucketService.uploadFileFromBuffer({
      buffer: Buffer.from(arrayBuffer as ArrayBuffer),
      resourceFolder: ResourceFolder.PRESENTATION,
      fileType: FileType.PPTX,
      userId: args.userId,
    });

    console.log(url);

    return url;
  }

  private async addText(
    slide: pptxgen.Slide,
    text: string,
    layoutOptions: Object,
  ): Promise<pptxgen.Slide> {
    slide.addText(text, layoutOptions);
    return slide;
  }

  private async addImage(
    slide: pptxgen.Slide,
    src: string,
  ): Promise<pptxgen.Slide> {
    slide.addImage({
      path: src,
    });
    return slide;
  }

  private async addBackgroundImage(
    slide: pptxgen.Slide,
    src: string,
  ): Promise<pptxgen.Slide> {
    slide.background = {
      path: src,
    };
    return slide;
  }

  private async addBackground(
    slide: pptxgen.Slide,
    background: string,
  ): Promise<pptxgen.Slide> {
    slide.background = {
      fill: background,
    };
    return slide;
  }
}
