import 'package:flutter/material.dart';
import 'screens/HomeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quaestor App',
      theme: ThemeData(
        primaryColor: const Color(0xFFF2F2F2),
      ),
      home: const HomeScreen(),
    );
  }
}