import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { Observable } from 'rxjs';
import { CryptoService } from 'src/users/crytpo.service';

@Injectable()
export class WsGuard implements CanActivate {
  constructor(private cryptoService: CryptoService) {}

  canActivate(
    context: ExecutionContext,
  ): boolean | Promise<boolean> | Observable<boolean> {
    const bearerToken = context.switchToWs().getClient().handshake
      .headers.authorization;
    if (!bearerToken) {
      return false;
    }

    const user = this.cryptoService.decodeAccessToken(
      bearerToken.split(' ')[1],
    );
    return !!user;
  }
}
