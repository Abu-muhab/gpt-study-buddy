import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gpt_study_buddy/common/colors.dart';
import 'package:gpt_study_buddy/features/chat/views/chats_view.dart';
import 'package:gpt_study_buddy/features/navigation/app_views.dart';
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
        child: Container(
          color: AppColors.primaryColor[100],
        ),
        fabIcon: const Icon(
          Icons.note_add,
          color: Colors.white,
        ),
        fabOnPressed: () {},
      ),
    ]);
  }
}
