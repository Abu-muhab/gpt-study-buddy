import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gpt_study_buddy/features/calendar/views/calendar_view.dart';
import 'package:gpt_study_buddy/features/chat/views/chats_view.dart';
import 'package:gpt_study_buddy/features/navigation/app_views.dart';
import 'package:gpt_study_buddy/features/notes/views/notes_view.dart';
import 'package:gpt_study_buddy/features/tab_scaffold.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeViewTabScaffold(tabs: [
      HomeViewTabItem(
        name: 'Chats',
        icon: const Icon(Icons.chat),
        child: const ChatsView(),
        fabIcon: const Icon(
          Icons.message_outlined,
          color: Colors.white,
        ),
        fabOnPressed: () {
          context.go(AppViews.createBot);
        },
      ),
      HomeViewTabItem(
        name: 'Notes',
        icon: const Icon(Icons.note),
        child: const NotesView(),
        fabIcon: const Icon(
          Icons.note_add,
          color: Colors.white,
        ),
        fabOnPressed: () {
          context.go(AppViews.createNotes);
        },
      ),
      HomeViewTabItem(
        name: 'Calendar',
        icon: const Icon(Icons.calendar_month_outlined),
        child: CalendarTabView(),
        fabIcon: const Icon(
          Icons.edit_calendar_outlined,
          color: Colors.white,
        ),
        fabOnPressed: () {
          context.go(AppViews.createEvent);
        },
      ),
    ]);
  }
}
