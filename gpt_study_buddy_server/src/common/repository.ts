export abstract class Entity {
  abstract id: String;
}

export abstract class Repository<T extends Entity> {
  abstract add(entity: T): Promise<void>;
  abstract update(entity: T): Promise<void>;
  abstract delete(entity: T): Promise<void>;
  abstract nextId(): Promise<string>;
  abstract findById(id: String): Promise<T>;
}
