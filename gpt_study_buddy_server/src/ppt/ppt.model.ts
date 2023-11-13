export interface Ppt {
  author?: string;
  subject?: string;
  title?: string;
  slides: Slide[];
}

export interface Slide {
  elements: SlideElement[];
}

export enum SlideElementType {
  TEXT = 'TEXT',
  IMAGE = 'IMAGE',
}

export namespace SlideElementType {
  export function fromString(value: string): SlideElementType {
    switch (value.toLowerCase()) {
      case 'text':
        return SlideElementType.TEXT;
      case 'image':
        return SlideElementType.IMAGE;
      default:
        throw new Error(`Invalid value: ${value}`);
    }
  }
}

export interface SlideElement {
  type: SlideElementType;
  layoutOptions: Object;
}

export interface TextElement extends SlideElement {
  type: SlideElementType.TEXT;
  text: string;
}

export interface ImageElement extends SlideElement {
  type: SlideElementType.IMAGE;
  src: string;
}
