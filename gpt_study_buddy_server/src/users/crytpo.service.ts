import { Injectable } from '@nestjs/common';
import { hash, compare } from 'bcryptjs';
import * as jwt from 'jsonwebtoken';

@Injectable()
export class CryptoService {
  async hasPassword(password: string): Promise<string> {
    return hash(password, 10);
  }

  async comparePassword(
    password: string,
    hashedPassword: string,
  ): Promise<boolean> {
    return compare(password, hashedPassword);
  }

  async generateAccessToken(payload: any): Promise<string> {
    const token = jwt.sign(payload, process.env.JWT_SECRET || 'iHeardARumour', {
      expiresIn: '1d',
    });
    return token;
  }

  async decodeAccessToken(token: string): Promise<any | null | undefined> {
    try {
      const decoded = jwt.verify(
        token,
        process.env.JWT_SECRET || 'iHeardARumour',
      );
      return decoded;
    } catch (error) {
      return null;
    }
  }
}
