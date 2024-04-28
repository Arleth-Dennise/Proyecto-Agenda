import 'package:agenda/calendario.dart';
import 'package:agenda/event.dart';
import 'package:flutter/material.dart';
import 'package:agenda/event_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Event? get event => null;
Widget build(BuildContext context) {
    return MaterialApp(
      title: "Agenda",
      debugShowCheckedModeBanner: false,
      home: Calendar(),
    );
  }
}
