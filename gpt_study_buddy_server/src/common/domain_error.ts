export class DomainError extends Error {
  public name: string;
  public message: string;
  public type: DomainErrorType;

  constructor(type: DomainErrorType, message: string) {
    super(message);
    this.type = type;
    this.name = this.constructor.name;
    this.message = message;
  }
}

export enum DomainErrorType {
  BadRequest = 'BadRequest',
  Unauthorized = 'Unauthorized',
  Forbidden = 'Forbidden',
  NotFound = 'NotFound',
}

export namespace DomainError {
  export class RequiredPropertyError extends DomainError {
    constructor(property: string) {
      super(DomainErrorType.BadRequest, `${property} is required`);
    }
  }

  export class InvalidPropertyError extends DomainError {
    constructor(property: string, value: string) {
      super(DomainErrorType.BadRequest, `Invalid ${property}: ${value}`);
    }
  }

  export class UnauthorizedOperationError extends DomainError {
    constructor() {
      super(DomainErrorType.Unauthorized, 'Unauthorized operation');
    }
  }
}
