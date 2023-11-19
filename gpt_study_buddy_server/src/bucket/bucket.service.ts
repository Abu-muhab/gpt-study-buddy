import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { randomUUID } from 'crypto';
import firebaseAdmin from 'firebase-admin';
import { getDownloadURL } from 'firebase-admin/storage';
import stream from 'stream';
import { BucketFileRepository } from './bucket.repository';
import { BucketFile } from './bucket_file.model';
import axios from 'axios';
import { FileTypes } from './mimetype';

export enum ResourceFolder {
  PRESENTATION = 'presentation',
  IMAGES = 'images',
}

export namespace ResourceFolder {
  export function fromString(value: string): ResourceFolder {
    switch (value) {
      case 'presentation':
        return ResourceFolder.PRESENTATION;
      case 'images':
        return ResourceFolder.IMAGES;
      default:
        throw new HttpException(
          'Invalid resource name',
          HttpStatus.BAD_REQUEST,
        );
    }
  }

  export function allResourceNames(): Array<ResourceFolder> {
    return [ResourceFolder.PRESENTATION, ResourceFolder.IMAGES];
  }
}

@Injectable()
export class BucketService {
  constructor(private readonly bucketfileRepository: BucketFileRepository) {}

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

      const folder = `users/${params.userId}/${params.resourceFolder}`;
      const name = `${randomUUID()}${params.file.name}`;
      const blob = bucket.file(`${folder}/${name}`);
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
        const bukcetFile = await firebaseAdmin
          .storage()
          .bucket()
          .file(blob.name)
          .get();
        await this.bucketfileRepository.add(
          new BucketFile({
            id: randomUUID(),
            userId: params.userId,
            name: name,
            folder: folder,
            type: bukcetFile[0].metadata.contentType,
            url: downloadUrl,
          }),
        );
        resolve(downloadUrl);
      });

      blobStream.end(params.file.arrayBuffer());
    });
  }

  public uploadFileFromBuffer(params: {
    buffer: Buffer;
    resourceFolder: ResourceFolder;
    fileType: { extension: string; mimeType: string };
    userId: string;
  }): Promise<string> {
    const bucket = firebaseAdmin.storage().bucket();

    return new Promise<string>((resolve, reject) => {
      if (!params.buffer) {
        reject('No buffer provided');
        return;
      }

      const folder = `users/${params.userId}/${params.resourceFolder}`;
      const name = `${randomUUID()}${params.fileType.extension}`;
      const blob = bucket.file(
        `${folder}/${name}`, // Replace with your desired filename
      );

      // Create a ReadableStream from the buffer
      const bufferStream = new stream.PassThrough();
      bufferStream.end(params.buffer);

      const blobStream = blob.createWriteStream({
        resumable: false,
        metadata: {
          contentType: params.fileType.mimeType,
        },
      });

      blobStream.on('error', (error) => {
        reject('Error uploading file from buffer: ' + error);
      });

      blobStream.on('finish', async () => {
        const downloadUrl = await getDownloadURL(blob);
        const bukcetFile = await firebaseAdmin
          .storage()
          .bucket()
          .file(blob.name)
          .get();
        await this.bucketfileRepository.add(
          new BucketFile({
            id: randomUUID(),
            userId: params.userId,
            name: name,
            folder: folder,
            type: bukcetFile[0].metadata.contentType,
            url: downloadUrl,
          }),
        );
        resolve(downloadUrl);
      });

      // Pipe the buffer stream to the blob stream
      bufferStream.pipe(blobStream);
    });
  }

  public async uploadImageFromUrl(params: {
    url: string;
    userId: string;
  }): Promise<string> {
    const response = await axios.get(params.url, {
      responseType: 'arraybuffer',
    });
    const buffer = Buffer.from(response.data, 'binary');

    return await this.uploadFileFromBuffer({
      buffer: buffer,
      resourceFolder: ResourceFolder.IMAGES,
      fileType: FileTypes.png,
      userId: params.userId,
    });
  }
}
