import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gpt_study_buddy/chat/chat_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: primaryColor,
      ),
      home: const ChatView(),
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
