import 'package:flutter/material.dart';

class Event {
  final String title;
  final String description;
  final TimeOfDay time;

  Event({required this.title, required this.description, required this.time});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'time': '${time.hour}:${time.minute}',
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
  final timeParts = json['time'].split(':');
  final hour = int.parse(timeParts[0]);
  final minute = int.parse(timeParts[1]);
  
  return Event(
    title: json['title'],
    description: json['description'],
    time: TimeOfDay(hour: hour, minute: minute),
  );
}
}