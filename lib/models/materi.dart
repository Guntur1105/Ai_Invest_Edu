import 'package:flutter/material.dart';

class Materi {
  final String title;
  final String description;
  final String explanation;
  final List<String> points;
  final IconData icon;
  final Color color;

  Materi({
    required this.title,
    required this.description,
    required this.explanation,
    required this.points,
    required this.icon,
    required this.color,
  });
}