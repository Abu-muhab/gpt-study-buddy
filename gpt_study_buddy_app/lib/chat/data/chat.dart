import 'package:gpt_study_buddy/bot/data/bot.dart';
import 'package:gpt_study_buddy/chat/data/message.dart';

class Chat {
  Chat({
    required this.bot,
    required this.lastMessage,
  });

  final Bot bot;
  final Message lastMessage;
}
