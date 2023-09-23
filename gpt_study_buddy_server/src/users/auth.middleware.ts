import { Injectable, NestMiddleware } from '@nestjs/common';
import { User } from './user.model';
import { Request, Response } from 'express';
import { CryptoService } from './crytpo.service';

@Injectable()
export class AuthMiddleware implements NestMiddleware {
  constructor(private cryptoService: CryptoService) {}
  async use(req: UserAuthRequest, res: Response, next: Function) {
    const unAuthorizedPayload = { message: 'Unauthorized' };
    try {
      const token = req.headers['authorization'];
      if (!token) {
        return res.status(401).json(unAuthorizedPayload);
      }

      //get authenticated user
      const user = await this.cryptoService.decodeAccessToken(
        token.split(' ')[1],
      );
      if (!user) {
        return res.status(401).json(unAuthorizedPayload);
      }
      req.user = user;

      next();
    } catch (e) {
      return res.status(401).json(unAuthorizedPayload);
    }
  }
}

interface UserAuthRequest extends Request {
  user: User;
}
