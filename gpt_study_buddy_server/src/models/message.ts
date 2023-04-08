export interface Message {
  message: string;
  senderId: string;
  receiverId: string;
  type: string;
  timestamp: Date;
  messageId: string;
}
