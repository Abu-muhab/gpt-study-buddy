import 'dart:async';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gpt_study_buddy/chat/data/message.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:uuid/uuid.dart';

class MessageRepository {
  MessageRepository() {
    _initializeSoketConnection();
  }

  late io.Socket socket;
  final StreamController<Message> _messageStreamController =
      StreamController<Message>.broadcast();
  final List<Message> _currentMessages = [];

  void _initializeSoketConnection() {
    socket = io.io(dotenv.env['SERVER_URL'],
        io.OptionBuilder().setTransports(['websocket']).build());

    socket.onConnect((_) {
      log('connected');
    });

    socket.onError((data) {
      log('error: $data');
    });

    socket.on('message', (data) {
      try {
        if (data == null) return;
        final Map<String, dynamic> message = data;
        _messageStreamController.add(Message.fromJson(message));
        _currentMessages.add(Message.fromJson(message));
      } catch (_) {}
    });
  }

  Stream<Message> get messages => _messageStreamController.stream;

  void sendTextMessage({
    required String senderId,
    required String receiverId,
    required String text,
  }) {
    if (!socket.connected) {
      _initializeSoketConnection();
      return;
    }

    Message message = Message(
      message: text,
      senderId: senderId,
      receiverId: receiverId,
      type: 'text',
      timestamp: DateTime.now(),
      messageId: _nextMessageId(),
    );

    _messageStreamController.add(message);
    _currentMessages.add(message);

    socket.emit('message', {
      "messages": _currentMessages,
      "userId": senderId,
    });
  }

  String _nextMessageId() {
    var uuid = const Uuid();
    return uuid.v4() + uuid.v4();
  }
}
