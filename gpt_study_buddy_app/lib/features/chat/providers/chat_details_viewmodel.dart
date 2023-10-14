import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/features/auth/providers/auth_service_provider.dart';
import 'package:gpt_study_buddy/features/bot/data/bot.dart';
import 'package:gpt_study_buddy/features/chat/data/message.dart';
import 'package:gpt_study_buddy/features/chat/data/message_repo.dart';

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

  final List<String> _selectedMessages = [];
  List<String> get selectedMessages => [..._selectedMessages];

  bool _selectionMode = false;
  bool get selectionMode => _selectionMode;
  set selectionMode(bool selectionMode) {
    _selectionMode = selectionMode;
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
              participant1: this.bot?.id ?? "", participant2: userId) ||
          message.isEmpty) {
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

  void clearChat() {
    messageRepository.clearConversation(
      userId: authServiceProvider.authToken!.user!.id,
      botId: bot!.id,
    );
  }

  void toggleMessageSelection({
    required String messageId,
  }) {
    if (_selectedMessages.contains(messageId)) {
      _selectedMessages.remove(messageId);
    } else {
      _selectedMessages.add(messageId);
    }
    if (_selectedMessages.isEmpty) {
      selectionMode = false;
    }
    notifyListeners();
  }

  Future<void> deleteSelectedMessages() async {
    await messageRepository.deleteMessages(
      userId: authServiceProvider.authToken!.user!.id,
      botId: bot!.id,
      messageIds: _selectedMessages,
    );
    _selectedMessages.clear();
    selectionMode = false;
  }
}
