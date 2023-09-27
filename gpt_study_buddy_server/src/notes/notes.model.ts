import { DomainError } from '../common/domain_error';
import { Entity } from '../common/repository';

export class Note extends Entity {
  private _id: string;
  private _title: string;
  private _content: string;
  private _lastUpdated: string;
  private _userId: string;

  constructor(params: {
    id: string;
    title: string;
    content: string;
    lastUpdated: string;
    userId: string;
  }) {
    super();
    this.id = params.id;
    this.title = params.title;
    this.content = params.content;
    this.lastUpdated = params.lastUpdated;
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

  public get title(): string {
    return this._title;
  }

  private set title(value: string) {
    this._title = value;
  }

  public get content(): string {
    return this._content;
  }

  private set content(value: string) {
    if (!value || value.length < 1) {
      throw new DomainError.RequiredPropertyError('content');
    }
    this._content = value;
  }

  public get lastUpdated(): string {
    return this._lastUpdated;
  }

  private set lastUpdated(value: string) {
    if (!value) {
      this._lastUpdated = new Date().toISOString();
      return;
    }

    this._lastUpdated = value;
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
