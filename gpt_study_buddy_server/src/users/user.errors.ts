import { DomainError, DomainErrorType } from 'src/common/domain_error';

export namespace UserError {
  export class UserAlreadyExists extends DomainError {
    constructor() {
      super(DomainErrorType.BadRequest, 'User already exists');
    }
  }
}
