import 'package:flutter/material.dart';
import 'location.dart';

class Institution {
  final String id;
  final Location location;
  final String code;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Color background;

  Institution({
    required this.id,
    required this.location,
    required this.code,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  }) : background = _generateColor(id);

  static Color _generateColor(String input) {
    final int hash = input.hashCode;
    final int r = (hash & 0xFF0000) >> 16;
    final int g = (hash & 0x00FF00) >> 8;
    final int b = (hash & 0x0000FF);
    return Color.fromARGB(255, r, g, b);
  }
}
