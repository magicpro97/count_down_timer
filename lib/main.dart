import 'package:count_down_timer/screens/setting_page.dart';
import 'package:count_down_timer/screens/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/home': (_) => const HomePage(),
        '/setting': (_) => const SettingPage(),
        '/': (_) => const SplashPage(),
      },
    );
  }
}
