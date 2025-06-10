import 'package:flutter/material.dart';
import 'screens/welcome.dart';

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
      home: const WelcomeScreen(),
    );
  }
}