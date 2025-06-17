import 'package:flutter/material.dart';
import 'screens/welcome.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/home.dart';
import 'screens/cafe_detail.dart';
import 'main_layout.dart';

void main() {
  runApp(const BrewzzleApp());
}

class BrewzzleApp extends StatelessWidget {
  const BrewzzleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brewzzle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      initialRoute: '/welcome',

      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/main': (context) => const MainLayout(),
        '/cafe-detail': (context) => const CafeDetailScreen(),
      },
    );
  }
}