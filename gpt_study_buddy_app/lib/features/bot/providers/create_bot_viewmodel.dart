import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/features/bot/data/bot_service.dart';
import 'package:gpt_study_buddy/features/bot/data/bot.dart';
import 'package:gpt_study_buddy/features/chat/providers/chats_provider.dart';

enum CreateAssistantStep { name, usefulness, trait, language, interests }

List<Map<String, dynamic>> traits = [
  {
    "text": "Professional",
    "subText":
        "The AI assistant speaks in a formal and respectful tone, using appropriate titles and language in business and work-related contexts.",
  },
  {
    "text": "Witty",
    "subText":
        "The AI assistant has a quick and clever sense of humor, using puns, jokes, and pop culture references to entertain and engage the user",
  },
  {
    "text": "Informative",
    "subText":
        "The AI assistant has a serious and informative personality, providing detailed and accurate information on a variety of topics",
  },
  {
    "text": "Supportive",
    "subText":
        "The AI assistant has a nurturing and empathetic personality, providing encouragement and emotional support to the user.",
  },
];

class CreateBotViewmodel extends ChangeNotifier {
  CreateBotViewmodel({
    required this.botService,
    required this.chatsProvider,
  });
  final BotService botService;
  final ChatsProvider chatsProvider;

  int _stepIndex = 0;
  CreateAssistantStep get step => CreateAssistantStep.values[_stepIndex];

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  String? _name;
  String? get name => _name;
  set name(String? name) {
    _name = name;
    notifyListeners();
  }

  String? _helfulness;
  String? get helfulness => _helfulness;
  set helfulness(String? helfulness) {
    _helfulness = helfulness;
    notifyListeners();
  }

  String? _trait;
  String? get trait => _trait;
  set trait(String? trait) {
    _trait = trait;
    notifyListeners();
  }

  String? _language;
  String? get language => _language;
  set language(String? language) {
    _language = language;
    notifyListeners();
  }

  List<String> _interests = <String>[];
  List<String> get interests => _interests;
  set interests(List<String> interests) {
    _interests = interests;
    notifyListeners();
  }

  double get completionPercentage {
    return (_stepIndex + 1) / CreateAssistantStep.values.length;
  }

  bool get isLastStep => _stepIndex == CreateAssistantStep.values.length - 1;

  bool nextStep() {
    if (_stepIndex < CreateAssistantStep.values.length - 1) {
      _stepIndex++;
      notifyListeners();
      return true;
    }

    return false;
  }

  bool previousStep() {
    if (_stepIndex > 0) {
      _stepIndex--;
      notifyListeners();
      return true;
    }

    return false;
  }

  bool get canGoToNextStep {
    switch (step) {
      case CreateAssistantStep.name:
        return _name != null && _name!.isNotEmpty;
      case CreateAssistantStep.usefulness:
        return _helfulness != null && _helfulness!.isNotEmpty;
      case CreateAssistantStep.trait:
        return _trait != null && _trait!.isNotEmpty;
      case CreateAssistantStep.language:
        return _language != null && _language!.isNotEmpty;
      case CreateAssistantStep.interests:
        return _interests.isNotEmpty;
      default:
        return false;
    }
  }

  void addInterest(String interest) {
    _interests.add(interest);
    notifyListeners();
  }

  void removeInterest(String interest) {
    _interests.remove(interest);
    notifyListeners();
  }

  Future<void> createBot() async {
    try {
      loading = true;
      final Bot bot = await botService.createBot(
        name: name!,
        description: getBotSummary(),
      );
      chatsProvider.addChat(bot);
    } finally {
      loading = false;
    }
  }

  String getBotSummary() {
    return "$name is an AI assistant that is $helfulness and speaks $language. ${traits.firstWhere((element) => element["text"] == trait)["subText"]}}."
        "$name is interested in ${interests.join(", ")}";
  }

  void reset({bool notifyAllListeners = true}) {
    _stepIndex = 0;
    _name = null;
    _helfulness = null;
    _trait = null;
    _language = null;
    _interests = <String>[];
    if (notifyAllListeners) {
      notifyListeners();
    }
  }
}
