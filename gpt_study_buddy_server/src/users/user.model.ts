import { DomainError } from 'src/common/domain_error';
import { Entity } from 'src/common/repository';

export class User extends Entity {
  private _id: string;
  private _firstName: string;
  private _lastName: string;
  private _email: string;
  private _password: string;

  constructor(params: {
    id: string;
    firstName: string;
    lastName: string;
    email: string;
    password: string;
  }) {
    super();
    this.id = params.id;
    this.firstName = params.firstName;
    this.lastName = params.lastName;
    this.email = params.email;
    this.password = params.password;
  }

  public get id(): string {
    return this._id;
  }

  private set id(value: string) {
    if (!value) {
      throw new DomainError.RequiredPropertyError('id');
    }

    this._id = value;
  }

  public get firstName(): string {
    return this._firstName;
  }

  private set firstName(value: string) {
    if (!value) {
      throw new DomainError.RequiredPropertyError('firstName');
    }

    if (value.length < 1) {
      throw new DomainError.InvalidPropertyError('firstName', value);
    }

    this._firstName = value;
  }

  public get lastName(): string {
    return this._lastName;
  }

  private set lastName(value: string) {
    if (!value) {
      throw new DomainError.RequiredPropertyError('lastName');
    }

    if (value.length < 1) {
      throw new DomainError.InvalidPropertyError('lastName', value);
    }

    this._lastName = value;
  }

  public get email(): string {
    return this._email;
  }

  private set email(value: string) {
    if (!value) {
      throw new DomainError.RequiredPropertyError('email');
    }

    this._email = value;
  }

  public get password(): string {
    return this._password;
  }

  private set password(value: string) {
    if (!value) {
      throw new DomainError.RequiredPropertyError('password');
    }

    this._password = value;
  }
}
