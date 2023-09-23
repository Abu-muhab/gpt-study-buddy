import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gpt_study_buddy/features/auth/providers/auth_service_provider.dart';
import 'package:gpt_study_buddy/features/bot/providers/create_bot_viewmodel.dart';
import 'package:gpt_study_buddy/features/chat/providers/chat_details_viewmodel.dart';
import 'package:gpt_study_buddy/features/chat/providers/chats_provider.dart';
import 'package:gpt_study_buddy/features/navigation/app_router.dart';
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
      title: 'ChatABC',
      theme: ThemeData(
        primarySwatch: primaryColor,
      ),
      routerConfig: appRouter,
    );
  }
}

var primaryColor =
    MaterialColor(const Color.fromARGB(255, 2, 20, 48).value, const {
  50: Color.fromARGB(255, 2, 22, 54),
  100: Color.fromARGB(255, 2, 24, 60),
  200: Color.fromARGB(255, 2, 26, 66),
  300: Color.fromARGB(255, 2, 28, 72),
  400: Color.fromARGB(255, 2, 30, 78),
  500: Color.fromARGB(255, 2, 32, 84),
  600: Color.fromARGB(255, 2, 34, 90),
  700: Color.fromARGB(255, 2, 36, 96),
  800: Color.fromARGB(255, 2, 38, 102),
  900: Color.fromARGB(255, 2, 40, 108),
});
