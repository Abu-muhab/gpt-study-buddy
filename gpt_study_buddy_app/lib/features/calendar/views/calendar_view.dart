import 'package:flutter/material.dart';
import 'package:gpt_study_buddy/common/app_scaffold.dart';
import 'package:gpt_study_buddy/common/colors.dart';
import 'package:gpt_study_buddy/features/calendar/viewmodel/calendar_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class CalendarTabView extends StatelessWidget {
  const CalendarTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarViewmodel>(
      builder: (context, calendarViewmodel, _) {
        return AppScaffold(
          body: Container(
            color: AppColors.primaryColor[100],
            child: SfCalendarTheme(
              data: SfCalendarThemeData(
                  brightness: Brightness.dark, todayHighlightColor: Colors.red),
              child: SfCalendar(
                dataSource: calendarViewmodel.dataSource,
                headerStyle: const CalendarHeaderStyle(
                  textStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                scheduleViewMonthHeaderBuilder: (context, details) {
                  return Container(
                    color: AppColors.primaryColor[100],
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      DateFormat("MMMM yyyy").format(details.date),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                      ),
                    ),
                  );
                },
                loadMoreWidgetBuilder: (context, loadMoreAppointments) {
                  return FutureBuilder(
                    future: loadMoreAppointments(),
                    builder: (context, snapshot) {
                      return const Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          LinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blueAccent,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                cellBorderColor: Colors.grey,
                viewHeaderStyle: const ViewHeaderStyle(
                  dayTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                  dateTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                timeSlotViewSettings: const TimeSlotViewSettings(
                  timeTextStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                monthViewSettings: const MonthViewSettings(
                  monthCellStyle: MonthCellStyle(
                    textStyle: TextStyle(
                      color: Colors.white,
                    ),
                    leadingDatesTextStyle: TextStyle(
                      color: Colors.blueAccent,
                    ),
                    trailingDatesTextStyle: TextStyle(
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                showTodayButton: true,
                allowedViews: const <CalendarView>[
                  CalendarView.day,
                  CalendarView.week,
                  CalendarView.month,
                ],
                selectionDecoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                view: CalendarView.day,
              ),
            ),
          ),
        );
      },
    );
  }
}
