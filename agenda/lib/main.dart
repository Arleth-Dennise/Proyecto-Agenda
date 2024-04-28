//main.dart
import 'package:flutter/material.dart';
import 'package:prueba/event_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
Widget build(BuildContext context) {
    return MaterialApp(
      title: "Agenda",
      debugShowCheckedModeBanner: false,
    );
  }
}
