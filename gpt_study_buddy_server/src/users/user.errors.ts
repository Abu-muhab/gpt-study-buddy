import { DomainError, DomainErrorType } from 'src/common/domain_error';

export namespace UserError {
  export class UserAlreadyExists extends DomainError {
    constructor() {
      super(DomainErrorType.BadRequest, 'User already exists');
    }
  }

  export class UserNotFound extends DomainError {
    constructor() {
      super(DomainErrorType.NotFound, 'User not found');
    }
  }

  export class InvalidCredentials extends DomainError {
    constructor() {
      super(DomainErrorType.BadRequest, 'Invalid credentials');
    }
  }
}
