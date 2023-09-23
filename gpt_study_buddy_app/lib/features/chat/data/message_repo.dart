import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gpt_study_buddy/features/auth/providers/auth_service_provider.dart';
import 'package:gpt_study_buddy/features/chat/data/message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:uuid/uuid.dart';

class MessageRepository {
  MessageRepository({
    required this.sharedPreferences,
    required this.authServiceProvider,
  }) {
    _initializeSoketConnection();
  }

  final SharedPreferences sharedPreferences;
  final AuthServiceProvider authServiceProvider;

  late io.Socket socket;
  final StreamController<Message> _messageStreamController =
      StreamController<Message>.broadcast();

  void _initializeSoketConnection() {
    socket = io.io(
      dotenv.env['SERVER_URL'],
      io.OptionBuilder().setTransports(['websocket']).setExtraHeaders({
        'Authorization': "Bearer ${authServiceProvider.authToken!.token}",
      }).build(),
    );

    socket.onConnect((_) {
      log('connected');
    });

    socket.onError((data) {
      log('error: $data');
    });

    socket.on('message', (data) {
      try {
        if (data == null) return;
        final Map<String, dynamic> messageJson = data;
        final message = Message.fromJson(messageJson);
        saveMessage(message);
      } catch (_) {}
    });
  }

  Stream<Message> get messageStream => _messageStreamController.stream;

  Future<void> sendTextMessage({
    required String senderId,
    required String receiverId,
    required String text,
  }) async {
    Message message = Message(
      message: text,
      senderId: senderId,
      receiverId: receiverId,
      type: 'text',
      timestamp: DateTime.now(),
      messageId: _nextMessageId(),
    );

    await saveMessage(message);

    socket.emit('message', {
      "messages": await getConversation(
        userId: senderId,
        botId: receiverId,
      ),
      "userId": senderId,
      "chatBotId": receiverId,
    });
  }

  Future<void> saveMessage(Message message) async {
    final List<Message> messages = await allMessages();
    messages.add(message);
    sharedPreferences.setString('messages', jsonEncode(messages));
    _messageStreamController.add(message);
  }

  Future<List<Message>> allMessages() async {
    final List<Message> messages = [];
    final String? messagesJson = sharedPreferences.getString('messages');

    if (messagesJson == null) {
      return messages;
    }

    final List<dynamic> messagesMap = jsonDecode(messagesJson);
    for (final Map<String, dynamic> messageMap in messagesMap) {
      messages.add(Message.fromJson(messageMap));
    }

    return messages;
  }

  Future<List<Message>> getConversation({
    required String userId,
    required String botId,
  }) async {
    final List<Message> messages = await allMessages();
    final List<Message> conversation = messages.where((message) {
      return (message.senderId == userId && message.receiverId == botId) ||
          (message.senderId == botId && message.receiverId == userId);
    }).toList();
    return conversation;
  }

  Future<Message?> getLastMessage({
    required String userId,
    required String chatBotId,
  }) async {
    final List<Message> messages = await getConversation(
      userId: userId,
      botId: chatBotId,
    );

    if (messages.isEmpty) {
      return null;
    }

    return messages.last;
  }

  String _nextMessageId() {
    var uuid = const Uuid();
    return uuid.v4() + uuid.v4();
  }
}
