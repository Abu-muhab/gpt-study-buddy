import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/features/auth/providers/auth_service_provider.dart';
import 'package:gpt_study_buddy/features/notes/data/note.dart';
import 'package:gpt_study_buddy/features/notes/data/notes_service.dart';

class NotesProvider extends ChangeNotifier {
  NotesProvider({
    required this.notesService,
    required this.authServiceProvider,
  });

  final NotesService notesService;
  final AuthServiceProvider authServiceProvider;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _failedFetch = false;
  bool get failedFetch => _failedFetch;
  set failedFetch(bool value) {
    _failedFetch = value;
    notifyListeners();
  }

  List<Note> _notes = [];
  List<Note> get notes => _notes;
  set notes(List<Note> value) {
    _notes = value;
    notifyListeners();
  }

  Future<void> init() async {
    await fetchNotes();
  }

  Future<void> fetchNotes() async {
    try {
      if (isLoading) {
        return;
      }

      isLoading = true;
      failedFetch = false;
      final List<Note> notes = await notesService.getNotes();
      this.notes = notes;
    } catch (err, stack) {
      log('fetchNotes error: $err, stack: $stack');
      failedFetch = true;
    } finally {
      isLoading = false;
    }
  }

  Future<void> addNote({
    required String content,
    required String title,
  }) async {
    try {
      if (isLoading) {
        return;
      }

      isLoading = true;
      final Note newNote = await notesService.createNote(
        content: content,
        title: title,
      );
      notes = [...notes, newNote];
    } catch (err, stack) {
      log('addNote error: $err, stack: $stack');
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  Future<void> updateNote({
    required String content,
    required String title,
    required String id,
  }) async {
    try {
      if (isLoading) {
        return;
      }

      isLoading = true;
      final Note updatedNote = await notesService.updateNote(
        content: content,
        title: title,
        id: id,
      );
      notes = [
        for (final note in notes)
          if (note.id == id) updatedNote else note,
      ];
    } catch (err, stack) {
      log('updateNote error: $err, stack: $stack');
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  Future<void> deleteNote({required String id}) async {
    try {
      if (isLoading) {
        return;
      }

      isLoading = true;
      await notesService.deleteNote(
        id: id,
      );
      notes = [
        for (final note in notes)
          if (note.id != id) note,
      ];
    } catch (err, stack) {
      log('deleteNote error: $err, stack: $stack');
      rethrow;
    } finally {
      isLoading = false;
    }
  }
}
