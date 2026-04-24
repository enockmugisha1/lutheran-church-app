import 'package:flutter/material.dart';

class LiturgicalColors {
  // Liturgical Season Colors — rich, vibrant tones
  static const Color purple = Color(0xFF5C2E8A); // Advent, Lent — deep violet
  static const Color white = Color(0xFFF5F0DC); // Christmas, Easter, Trinity — warm white/cream
  static const Color gold = Color(0xFFD4AF37); // Christmas, Easter (alternate) — rich gold
  static const Color green = Color(0xFF2E7D32); // Ordinary Time — forest green
  static const Color red = Color(0xFFC62828); // Pentecost, Reformation, Martyrs — deep red
  static const Color black = Color(0xFF1A1A1A); // Good Friday — soft black

  // Get color by season
  static Color getSeasonColor(String season) {
    switch (season.toLowerCase()) {
      case 'advent':
      case 'lent':
        return purple;
      case 'christmas':
      case 'easter':
      case 'trinity':
      case 'epiphany':
        return white;
      case 'pentecost':
      case 'reformation':
        return red;
      case 'ordinary':
      case 'time after pentecost':
      case 'time after epiphany':
        return green;
      case 'good friday':
        return black;
      default:
        return green;
    }
  }

  // Complementary colors for UI elements
  static const Color lightPurple = Color(0xFFE6D4F0);
  static const Color lightGreen = Color(0xFFD4F0D4);
  static const Color lightRed = Color(0xFFF0D4D4);
  static const Color lightGold = Color(0xFFFFF8E1);
}
