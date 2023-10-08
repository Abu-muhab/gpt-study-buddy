import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gpt_study_buddy/common/exception.dart';
import 'package:gpt_study_buddy/common/http_client.dart';
import 'package:gpt_study_buddy/features/notes/data/note.dart';

class NotesService {
  NotesService({
    required this.httpClient,
  });

  final AppHttpClient httpClient;

  Future<Note> createNote({
    required String content,
    required String title,
  }) async {
    final FailureOrResponse response =
        await httpClient.post('${dotenv.env['SERVER_URL']}/notes', {
      'content': content,
      'title': title,
      'date': DateTime.now().toIso8601String(),
    });

    if (response.isSuccess) {
      return Note.fromMap(response.response);
    } else {
      throw DomainException(response.errorMessage);
    }
  }

  Future<List<Note>> getNotes() async {
    final FailureOrResponse response =
        await httpClient.get('${dotenv.env['SERVER_URL']}/notes');

    if (response.isSuccess) {
      final List<Note> notes = <Note>[];
      for (final Map<String, dynamic> noteMap in response.response) {
        notes.add(Note.fromMap(noteMap));
      }
      return notes;
    } else {
      log(response.errorMessage.toString());
      throw DomainException(response.errorMessage);
    }
  }
}
