import 'package:gpt_study_buddy/features/calendar/data/event.dart';
import 'package:gpt_study_buddy/features/calendar/data/event_repo.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDataSource extends CalendarDataSource<Event> {
  EventDataSource({
    required this.eventRepository,
  }) {
    appointments = <Event>[];
  }

  final EventRepository eventRepository;

  @override
  DateTime getStartTime(int index) {
    return appointments![index].startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].endTime;
  }

  @override
  String getSubject(int index) {
    return appointments![index].name;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  Future<void> handleLoadMore(DateTime startDate, DateTime endDate) async {
    try {
      final List<Event> events = await eventRepository.getEvents(
        startTime: startDate,
        endTime: endDate,
      );
      appointments!.addAll(events);
      notifyListeners(CalendarDataSourceAction.add, events);
    } catch (_) {
      notifyListeners(CalendarDataSourceAction.add, []);
    }
  }

  void addEvent(Event event) {
    appointments!.add(event);
    notifyListeners(CalendarDataSourceAction.add, [event]);
  }
}
