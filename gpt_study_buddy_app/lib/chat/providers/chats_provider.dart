import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/auth/providers/auth_service_provider.dart';
import 'package:gpt_study_buddy/bot/bot_service.dart';
import 'package:gpt_study_buddy/bot/data/bot.dart';
import 'package:gpt_study_buddy/chat/data/chat.dart';
import 'package:gpt_study_buddy/chat/data/message.dart';
import 'package:gpt_study_buddy/chat/data/message_repo.dart';

class ChatsProvider extends ChangeNotifier {
  ChatsProvider({
    required this.botService,
    required this.messageRepository,
    required this.authServiceProvider,
  }) {
    init();
  }

  final BotService botService;
  final MessageRepository messageRepository;
  final AuthServiceProvider authServiceProvider;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<Chat> _chats = [];
  List<Chat> get chats => _chats;
  set chats(List<Chat> value) {
    _chats = value;
    notifyListeners();
  }

  Future<void> init() async {
    await fetchChats();
    messageRepository.messageStream.listen((message) async {
      await fetchChats();
    });
  }

  Future<void> fetchChats() async {
    try {
      isLoading = true;
      final List<Bot> bots = await botService.getBots();
      final List<Chat> chats = <Chat>[];

      for (final Bot bot in bots) {
        final Message? lastMessage = await messageRepository.getLastMessage(
          userId: authServiceProvider.authToken!.user!.id,
          chatBotId: bot.id,
        );
        final Chat chat = Chat(
          bot: bot,
          lastMessage: lastMessage ?? Message.empty(),
        );
        chats.add(chat);
      }
      this.chats = chats;
    } catch (err, stack) {
      log('fetchChats error: $err, stack: $stack');
    } finally {
      isLoading = false;
    }
  }

  void addChat(Bot bot) {
    final Chat chat = Chat(
      bot: bot,
      lastMessage: Message.empty(),
    );
    chats = [...chats, chat];
  }
}
