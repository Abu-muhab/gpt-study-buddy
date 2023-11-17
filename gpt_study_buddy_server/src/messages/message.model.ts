import { CompletionCreatedResource } from './gpt.model';

export interface Message {
  message: string;
  senderId: string;
  receiverId: string;
  type: string;
  timestamp: Date;
  messageId: string;
  createdResources?: CompletionCreatedResource[];
}
