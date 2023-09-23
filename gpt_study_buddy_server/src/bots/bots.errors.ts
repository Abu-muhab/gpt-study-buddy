import { DomainError, DomainErrorType } from 'src/common/domain_error';

export namespace BotError {
  export class BotAlreadyExists extends DomainError {
    constructor() {
      super(DomainErrorType.BadRequest, 'Bot already exists');
    }
  }

  export class BotNotFound extends DomainError {
    constructor() {
      super(DomainErrorType.NotFound, 'Bot not found');
    }
  }
}
