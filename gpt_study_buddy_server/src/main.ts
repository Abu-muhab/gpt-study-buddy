import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { ValidationPipe } from '@nestjs/common';
import mongoose from 'mongoose';
import { TrimPipe } from './users/auth.middleware';

declare const module: any;

async function bootstrap() {
  await mongoose.connect(process.env.DB_URL, { dbName: 'chatbot' });
  const app = await NestFactory.create(AppModule);
  app.useGlobalPipes(new TrimPipe());
  app.useGlobalPipes(new ValidationPipe());

  const config = new DocumentBuilder()
    .setTitle('Drop Gateway')
    .setDescription('The Drop Gateway API description')
    .setVersion('1.0')
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('docs', app, document);

  await app.listen(3000);

  if (module.hot) {
    module.hot.accept();
    module.hot.dispose(() => app.close());
  }
}
bootstrap();
