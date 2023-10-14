import { DomainError } from '../common/domain_error';
import { Entity } from '../common/repository';

export class Event extends Entity {
  private _id: string;
  private _name: string;
  private _startTime: Date;
  private _endTime: Date;
  private _isAllDay: boolean;
  private _userId: string;

  constructor(params: {
    id: string;
    name: string;
    startTime: Date;
    endTime: Date;
    isAllDay: boolean;
    userId: string;
  }) {
    super();
    this.id = params.id;
    this.name = params.name;
    this.startDate = params.startTime;
    this.endDate = params.endTime;
    this.isAllDay = params.isAllDay;
    this.userId = params.userId;

    if (this.startDate > this.endDate) {
      throw new DomainError.InvalidPropertyError(
        'startTime',
        'startTime must be before endTime',
      );
    }
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

  public set name(value: string) {
    if (!value || value.length < 1) {
      throw new DomainError.RequiredPropertyError('name');
    }

    this._name = value;
  }

  public get startDate(): Date {
    return this._startTime;
  }

  public set startDate(value: Date) {
    if (!value) {
      throw new DomainError.RequiredPropertyError('startTime');
    }

    this._startTime = value;
  }

  public get endDate(): Date {
    return this._endTime;
  }

  public set endDate(value: Date) {
    if (!value) {
      throw new DomainError.RequiredPropertyError('endTime');
    }

    this._endTime = value;
  }

  public get isAllDay(): boolean {
    return this._isAllDay;
  }

  public set isAllDay(value: boolean) {
    if (value == null || value == undefined) {
      throw new DomainError.RequiredPropertyError('isAllDay');
    }

    this._isAllDay = value;
  }

  public get userId(): string {
    return this._userId;
  }

  public set userId(value: string) {
    if (!value) {
      throw new DomainError.RequiredPropertyError('userId');
    }

    this._userId = value;
  }
}
