import {
  MiddlewareConsumer,
  Module,
  NestModule,
  RequestMethod,
} from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { UsersModule } from './users/users.module';
import { MessagesModule } from './messages/messages.module';
import { BotsModule } from './bots/bots.module';
import { AuthMiddleware } from './users/auth.middleware';
import { UsersController } from './users/users.controller';
import { BotsController } from './bots/bots.controller';
import { NotesModule } from './notes/notes.module';
import { NotesController } from './notes/notes.controller';

@Module({
  imports: [
    ConfigModule.forRoot(),
    UsersModule,
    MessagesModule,
    BotsModule,
    NotesModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer
      .apply(AuthMiddleware)
      .exclude(
        { path: 'users', method: RequestMethod.POST },
        { path: 'users/login', method: RequestMethod.POST },
      )
      .forRoutes(UsersController, BotsController, NotesController);
  }
}
