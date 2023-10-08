import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/features/calendar/data/event.dart';
import 'package:gpt_study_buddy/features/calendar/data/event_repo.dart';
import 'package:gpt_study_buddy/features/calendar/viewmodel/calendar_viewmodel.dart';

class CreateEventViewModel extends ChangeNotifier {
  CreateEventViewModel({
    required this.eventRepository,
    required this.calendarViewmodel,
  });

  final EventRepository eventRepository;
  final CalendarViewmodel calendarViewmodel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Event _event = Event.defaults();
  Event get event => _event;

  void updateEvent(Event event) {
    _event = event;
    if (event.endTime.isBefore(event.startTime)) {
      _event = _event.copyWith(
          endTime: event.startTime.add(const Duration(minutes: 1)));
    }
    notifyListeners();
  }

  Future<void> save() async {
    try {
      _isLoading = true;
      notifyListeners();
      final Event event = await eventRepository.add(this.event);
      calendarViewmodel.addEvent(event);
      _isLoading = false;
      _event = Event.defaults();
      notifyListeners();
    } catch (_) {
      _isLoading = false;
      rethrow;
    }
  }
}
