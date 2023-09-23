import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gpt_study_buddy/bot/data/bot.dart';
import 'package:gpt_study_buddy/common/exception.dart';
import 'package:gpt_study_buddy/common/http_client.dart';

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

  Future<List> getBots() async {
    final FailureOrResponse response =
        await httpClient.get('${dotenv.env['SERVER_URL']}/bots');

    if (response.isSuccess) {
      final List<Bot> bots = <Bot>[];
      for (final Map<String, dynamic> botMap in response.response) {
        bots.add(Bot.fromMap(botMap));
      }
      return bots;
    } else {
      throw DomainException(response.errorMessage);
    }
  }
}
