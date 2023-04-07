import {
  MessageBody,
  SubscribeMessage,
  WebSocketGateway,
} from '@nestjs/websockets';

@WebSocketGateway(8000)
export class ChatGateway {
  @SubscribeMessage('message')
  async handleMessage(@MessageBody() paylod: any): Promise<any> {
    const data = paylod;
    data.timestamp = new Date();

    const senderId = data.senderId;

    data.senderId = 'ai';
    data.receiverId = senderId;

    //delay for 1 second
    await new Promise((resolve) => setTimeout(resolve, 1000));

    return {
      event: 'message',
      data,
    };
  }
}
