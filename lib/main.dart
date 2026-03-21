import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Mastery League',
      home: Scaffold(
        appBar: AppBar(title: const Text('Habit Mastery League')),
        body: const Center(
          child: Text('App Started'),
        ),
      ),
    );
  }
}