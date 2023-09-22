import { Entity } from './repository';

export abstract class Mapper<EntityType extends Entity, Document> {
  abstract toPersistence(entity: EntityType): Document;
  abstract toDomain(document: Document): EntityType;
}
