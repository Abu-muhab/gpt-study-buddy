import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/features/calendar/viewmodel/calendar_datasource.dart';

class CalendarViewmodel extends ChangeNotifier {
  CalendarViewmodel({
    required this.dataSource,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final EventDataSource dataSource;
}
