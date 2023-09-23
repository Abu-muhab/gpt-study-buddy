import { DomainError } from 'src/common/domain_error';
import { Entity } from 'src/common/repository';

export class Bot extends Entity {
  private _id: string;
  private _name: string;
  private _slug: string;
  private _description: string;
  private _userId: string;

  constructor(params: {
    id: string;
    name: string;
    slug: string;
    description: string;
    userId: string;
  }) {
    super();
    this.id = params.id;
    this.name = params.name;
    this.slug = params.slug;
    this.description = params.description;
    this.userId = params.userId;
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

  public get name(): string {
    return this._name;
  }

  private set name(value: string) {
    if (!value) {
      throw new DomainError.RequiredPropertyError('name');
    }

    if (value.length < 2) {
      throw new DomainError.InvalidPropertyError(
        'name',
        'Name must be at least 2 characters long',
      );
    }

    this._name = value;
  }

  public get slug(): string {
    return this._slug;
  }

  private set slug(value: string) {
    if (!value) {
      throw new DomainError.RequiredPropertyError('slug');
    }

    this._slug = value;
  }

  public get description(): string {
    return this._description;
  }

  private set description(value: string) {
    if (!value) {
      throw new DomainError.RequiredPropertyError('description');
    }

    if (value.length < 10) {
      throw new DomainError.InvalidPropertyError(
        'description',
        'Description must be at least 10 characters long',
      );
    }

    this._description = value;
  }

  public get userId(): string {
    return this._userId;
  }

  private set userId(value: string) {
    if (!value) {
      throw new DomainError.RequiredPropertyError('userId');
    }

    this._userId = value;
  }
}
