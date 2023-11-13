import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { randomUUID } from 'crypto';
import firebaseAdmin from 'firebase-admin';
import { getDownloadURL } from 'firebase-admin/storage';
import stream from 'stream';

export enum ResourceFolder {
  PRESENTATION = 'presentation',
}

export enum FileType {
  PPTX = 'pptx',
  PDF = 'pdf',
}

export namespace ResourceFolder {
  export function fromString(value: string): ResourceFolder {
    switch (value) {
      case 'presentation':
        return ResourceFolder.PRESENTATION;
      default:
        throw new HttpException(
          'Invalid resource name',
          HttpStatus.BAD_REQUEST,
        );
    }
  }

  export function allResourceNames(): Array<ResourceFolder> {
    return [ResourceFolder.PRESENTATION];
  }
}

@Injectable()
export class BucketService {
  public uploadFile(params: {
    file: File;
    resourceFolder: ResourceFolder;
    userId: string;
  }): Promise<string> {
    const bucket = firebaseAdmin.storage().bucket();

    return new Promise<string>((resolve, reject) => {
      if (!params.file) {
        reject('No file provided');
        return;
      }

      const blob = bucket.file(
        `users/${params.userId}/${params.resourceFolder}/${params.file.name}`,
      );
      const blobStream = blob.createWriteStream({
        resumable: false,
        metadata: {
          contentType: params.file.type,
        },
      });

      blobStream.on('error', (error) => {
        reject('Error uploading file: ' + error);
      });

      blobStream.on('finish', async () => {
        const downloadUrl = await getDownloadURL(blob);
        resolve(downloadUrl);
      });

      blobStream.end(params.file.arrayBuffer());
    });
  }

  public uploadFileFromBuffer(params: {
    buffer: Buffer;
    resourceFolder: ResourceFolder;
    fileType: FileType;
    userId: string;
  }): Promise<string> {
    const bucket = firebaseAdmin.storage().bucket();

    return new Promise<string>((resolve, reject) => {
      if (!params.buffer) {
        reject('No buffer provided');
        return;
      }

      const blob = bucket.file(
        `users/${params.userId}/${params.resourceFolder}/${randomUUID()}.${
          params.fileType
        }`, // Replace with your desired filename
      );

      // Create a ReadableStream from the buffer
      const bufferStream = new stream.PassThrough();
      bufferStream.end(params.buffer);

      const blobStream = blob.createWriteStream({
        resumable: false,
        metadata: {
          contentType: 'application/octet-stream', // Adjust the content type if needed
        },
      });

      blobStream.on('error', (error) => {
        reject('Error uploading file from buffer: ' + error);
      });

      blobStream.on('finish', async () => {
        const downloadUrl = await getDownloadURL(blob);
        resolve(downloadUrl);
      });

      // Pipe the buffer stream to the blob stream
      bufferStream.pipe(blobStream);
    });
  }
}
