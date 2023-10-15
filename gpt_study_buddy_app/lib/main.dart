import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gpt_study_buddy/common/colors.dart';
import 'package:gpt_study_buddy/features/auth/providers/auth_service_provider.dart';
import 'package:gpt_study_buddy/features/bot/providers/create_bot_viewmodel.dart';
import 'package:gpt_study_buddy/features/calendar/viewmodel/calendar_viewmodel.dart';
import 'package:gpt_study_buddy/features/calendar/viewmodel/create_event_viewmodel.dart';
import 'package:gpt_study_buddy/features/chat/providers/chat_details_viewmodel.dart';
import 'package:gpt_study_buddy/features/chat/providers/chats_provider.dart';
import 'package:gpt_study_buddy/features/navigation/app_router.dart';
import 'package:gpt_study_buddy/features/notes/providers/notes_provider.dart';
import 'package:provider/provider.dart';

import 'injection_container.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await injectDependencies();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthServiceProvider>(
        create: (context) => sl(),
      ),
      ChangeNotifierProvider<CreateBotViewmodel>(
        create: (context) => sl(),
      ),
      ChangeNotifierProvider<ChatsProvider>(
        create: (context) => sl(),
      ),
      ChangeNotifierProvider<ChatDetailsViewModel>(
        create: (context) => sl(),
      ),
      ChangeNotifierProvider<CalendarViewmodel>(
        create: (context) => sl(),
      ),
      ChangeNotifierProvider<CreateEventViewModel>(
        create: (context) => sl(),
      ),
      ChangeNotifierProvider<NotesProvider>(
        create: (context) => sl(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'ChatBuddy',
      theme: ThemeData(
        primarySwatch: AppColors.primaryColor,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white,
        ),
      ),
      routerConfig: appRouter,
    );
  }
}
