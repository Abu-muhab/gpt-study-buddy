import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gpt_study_buddy/common/exception.dart';
import 'package:gpt_study_buddy/common/http_client.dart';
import 'package:gpt_study_buddy/features/bot/data/bot.dart';
import 'package:gpt_study_buddy/features/bot/data/question.dart';

class BotService {
  BotService({
    required this.httpClient,
  });

  final AppHttpClient httpClient;

  Future<Bot> createBot({
    required String name,
    required String description,
  }) async {
    final FailureOrResponse response =
        await httpClient.post('${dotenv.env['SERVER_URL']}/bots', {
      'name': name,
      'description': description,
    });

    if (response.isSuccess) {
      return Bot.fromMap(response.response);
    } else {
      throw DomainException(response.errorMessage);
    }
  }

  Future<List<Bot>> getBots() async {
    final FailureOrResponse response =
        await httpClient.get('${dotenv.env['SERVER_URL']}/bots');

    if (response.isSuccess) {
      final List<Bot> bots = <Bot>[];
      for (final Map<String, dynamic> botMap in response.response) {
        bots.add(Bot.fromMap(botMap));
      }
      return bots;
    } else {
      log(response.errorMessage.toString());
      throw DomainException(response.errorMessage);
    }
  }

  Future<List<Question>> getBotCreationQuestions() async {
    final FailureOrResponse response =
        await httpClient.get('${dotenv.env['SERVER_URL']}/bots/questions');

    if (response.isSuccess) {
      final List<Question> questions = <Question>[];
      for (final Map<String, dynamic> questionMap in response.response) {
        questions.add(Question.fromMap(questionMap));
      }
      return questions;
    } else {
      log(response.errorMessage.toString());
      throw DomainException(response.errorMessage);
    }
  }
}
