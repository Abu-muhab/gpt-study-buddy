import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gpt_study_buddy/common/exception.dart';
import 'package:gpt_study_buddy/common/http_client.dart';
import 'package:gpt_study_buddy/features/calendar/data/event.dart';

class EventRepository {
  EventRepository({
    required this.httpClient,
  });

  final AppHttpClient httpClient;

  Future<Event> add(Event event) async {
    final FailureOrResponse response = await httpClient.post(
        '${dotenv.env['SERVER_URL']}/events', event.toMap());

    if (response.isSuccess) {
      return Event.fromMap(response.response);
    } else {
      throw DomainException(response.errorMessage);
    }
  }

  Future<List<Event>> getEvents({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final FailureOrResponse response = await httpClient.get(
        '${dotenv.env['SERVER_URL']}/events?startTime=${startTime.toIso8601String()}&endTime=${endTime.toIso8601String()}');

    if (response.isSuccess) {
      final List<Event> events = <Event>[];
      for (final Map<String, dynamic> botMap in response.response) {
        events.add(Event.fromMap(botMap));
      }
      return events;
    } else {
      log(response.errorMessage.toString());
      throw DomainException(response.errorMessage);
    }
  }
}
