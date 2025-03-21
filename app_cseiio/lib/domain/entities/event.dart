import 'package:flutter/material.dart';

class Event {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final Color background;

  Event({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.description,
  }) : background = _generateColor(id); // Se genera el color a partir del ID

  static Color _generateColor(String input) {
    final int hash = input.hashCode;
    final int r = (hash & 0xFF0000) >> 16;
    final int g = (hash & 0x00FF00) >> 8;
    final int b = (hash & 0x0000FF);
    return Color.fromARGB(255, r, g, b);
  }
}
