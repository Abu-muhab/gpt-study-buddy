import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/auth/providers/auth_service_provider.dart';
import 'package:gpt_study_buddy/bot/data/bot.dart';
import 'package:gpt_study_buddy/chat/data/message.dart';
import 'package:gpt_study_buddy/chat/data/message_repo.dart';

class ChatDetailsViewModel extends ChangeNotifier {
  ChatDetailsViewModel({
    required this.messageRepository,
    required this.authServiceProvider,
  });

  final MessageRepository messageRepository;
  final AuthServiceProvider authServiceProvider;

  List<Message> _messages = [];
  List<Message> get messages => _messages;
  set messages(List<Message> messages) {
    _messages = messages;
    notifyListeners();
  }

  Bot? _bot;
  Bot? get bot => _bot;
  set bot(Bot? botId) {
    _bot = botId;
    notifyListeners();
  }

  Future<void> init({
    required Bot bot,
  }) async {
    this.bot = bot;
    final String userId = authServiceProvider.authToken!.user!.id;
    final List<Message> messages =
        await messageRepository.getConversation(userId: userId, botId: bot.id);
    this.messages = messages;

    messageRepository.messageStream.listen((message) async {
      if (message.isForChat(
          participant1: this.bot?.id ?? "", participant2: userId)) {
        this.messages = await messageRepository.getConversation(
          userId: userId,
          botId: bot.id,
        );
      }
    });
  }

  Future<void> sendTextMessage({
    required String text,
  }) async {
    await messageRepository.sendTextMessage(
      senderId: authServiceProvider.authToken!.user!.id,
      receiverId: bot!.id,
      text: text,
    );
  }
}
