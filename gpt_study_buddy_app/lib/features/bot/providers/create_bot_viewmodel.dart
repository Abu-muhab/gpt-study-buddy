import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/features/bot/data/bot_service.dart';
import 'package:gpt_study_buddy/features/bot/data/bot.dart';
import 'package:gpt_study_buddy/features/bot/data/question.dart';
import 'package:gpt_study_buddy/features/chat/providers/chats_provider.dart';

class CreateBotViewmodel extends ChangeNotifier {
  CreateBotViewmodel({
    required this.botService,
    required this.chatsProvider,
  }) {
    fetchQuestions();
  }

  final BotService botService;
  final ChatsProvider chatsProvider;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  List<Question>? _questions;
  List<Question>? get questions => _questions;

  int _currentQuestionId = 0;
  int get currentQuestionId => _currentQuestionId;

  final Map<int, List<QuestionOption>> _questionsSelectedOptions = {};
  Map<int, List<QuestionOption>> get questionsSelectedOptions =>
      {..._questionsSelectedOptions};

  Question getCreationStepQuestion(int currentQuestionId) {
    return questions!.firstWhere((element) => element.id == currentQuestionId);
  }

  List<QuestionOption> getQuestionSelectedOptions(int questionId) {
    return _questionsSelectedOptions[questionId] ?? [];
  }

  void setRadioSelectedOption(Question question, QuestionOption option) {
    _questionsSelectedOptions[question.id] = [option];
    notifyListeners();
  }

  void setCheckboxSelectedOption(Question question, QuestionOption option) {
    final List<QuestionOption> selectedOptions =
        _questionsSelectedOptions[question.id] ?? [];
    if (selectedOptions.contains(option)) {
      selectedOptions.remove(option);
    } else {
      selectedOptions.add(option);
    }
    _questionsSelectedOptions[question.id] = selectedOptions;
    notifyListeners();
  }

  bool allQuestionsAnswered() {
    return _questionsSelectedOptions.keys.every(
            (element) => _questionsSelectedOptions[element]!.isNotEmpty) &&
        _questionsSelectedOptions.keys.length == _questions!.length &&
        name != null;
  }

  bool questionAnswered(int questionId) {
    return _questionsSelectedOptions[questionId] != null &&
        _questionsSelectedOptions[questionId]!.isNotEmpty;
  }

  bool _errorFetchingQuestions = false;
  bool get errorFetchingQuestions => _errorFetchingQuestions;

  String? _name;
  String? get name => _name;
  set name(String? name) {
    _name = name;
    notifyListeners();
  }

  Future<void> fetchQuestions() async {
    try {
      loading = true;
      _questions = await botService.getBotCreationQuestions();
    } catch (err, stack) {
      log(err.toString(), stackTrace: stack);
      _errorFetchingQuestions = true;
    } finally {
      loading = false;
    }
  }

  double get completionPercentage {
    return questions == null ? 0 : (currentQuestionId + 1) / questions!.length;
  }

  bool get isLastStep => _currentQuestionId == questions!.length - 1;

  bool nextStep() {
    if (_currentQuestionId < questions!.length - 1) {
      _currentQuestionId = _currentQuestionId + 1;
      notifyListeners();
      return true;
    }

    return false;
  }

  bool previousStep() {
    if (_currentQuestionId > 0) {
      _currentQuestionId = _currentQuestionId - 1;
      notifyListeners();
      return true;
    }

    return false;
  }

  bool get canGoToNextStep {
    if (_currentQuestionId == 0) {
      return name != null;
    } else {
      return questionAnswered(_currentQuestionId);
    }
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
    return """
$name is an AI assistant. The following describes the behavior of $name:
${questions!.map((e) => getQuestionSelectedOptionsSummary(e)).join("\n")}
    """
        .trim();
  }

  String getQuestionSelectedOptionsSummary(Question question) {
    if (question.id == 0) {
      return "";
    }

    final List<QuestionOption> selectedOptions =
        getQuestionSelectedOptions(question.id);
    if (selectedOptions.isEmpty) {
      return "";
    } else {
      return """
${question.attribute}: ${selectedOptions.map((QuestionOption e) => "${e.label} (${e.systemDescription})").join(", ")}
 """;
    }
  }

  void reset({bool notifyAllListeners = true}) {
    _currentQuestionId = 0;
    _name = null;
    _questionsSelectedOptions.clear();
    if (notifyAllListeners) {
      notifyListeners();
    }
  }
}
