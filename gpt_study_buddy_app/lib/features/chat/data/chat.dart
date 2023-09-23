import 'package:gpt_study_buddy/features/bot/data/bot.dart';
import 'package:gpt_study_buddy/features/chat/data/message.dart';

class Chat {
  Chat({
    required this.bot,
    required this.lastMessage,
  });

  final Bot bot;
  final Message lastMessage;
}
