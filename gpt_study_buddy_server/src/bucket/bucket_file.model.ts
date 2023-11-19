import { DomainError } from '../common/domain_error';
import { Entity } from '../common/repository';

export class BucketFile extends Entity {
  private _id: string;
  private _userId: string;
  private _name: string;
  private _folder: string;
  private _type: string;
  private _url: string;

  constructor(params: {
    id: string;
    userId: string;
    name: string;
    folder: string;
    type: string;
    url: string;
  }) {
    super();
    this.id = params.id;
    this.userId = params.userId;
    this.name = params.name;
    this.folder = params.folder;
    this.type = params.type;
    this.url = params.url;
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

  public get userId(): string {
    return this._userId;
  }

  private set userId(value: string) {
    if (!value) {
      throw new DomainError.RequiredPropertyError('userId');
    }

    this._userId = value;
  }

  public get name(): string {
    return this._name;
  }

  private set name(value: string) {
    if (!value) {
      throw new DomainError.RequiredPropertyError('fileName');
    }

    this._name = value;
  }

  public get folder(): string {
    return this._folder;
  }

  private set folder(value: string) {
    if (!value) {
      throw new DomainError.RequiredPropertyError('fileFolder');
    }

    this._folder = value;
  }

  public get type(): string {
    return this._type;
  }

  private set type(value: string) {
    if (!value) {
      throw new DomainError.RequiredPropertyError('fileType');
    }

    this._type = value;
  }

  public get url(): string {
    return this._url;
  }

  private set url(value: string) {
    if (!value) {
      throw new DomainError.RequiredPropertyError('fileUrl');
    }

    this._url = value;
  }
}
