import 'package:flutter/material.dart';

class AppColors {
  static const Color peach = Color(0xFFFFEBD8);
  static const Color blush = Color(0xFFF8E4E0);
  static const Color coralPink = Color(0xFFF4C5C6);
  static const Color mutedRose = Color(0xFFCF948E);
  static const Color dustyPink = Color(0xFFDD7E81);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color yellow = Color(0xFFE3B967);
  static const Color gold = Color(0xFFAC7943);

  static const Color buttonBorder = Color(0xFFAC7942);
  static const Color sliderActiveColor = Color(0xFFF0AC6E);
  static const Color sliderInactiveColor = Color(0xFFE3B967);

  static const LinearGradient backgroundColor = LinearGradient(
    colors: [
      Color.fromARGB(255, 0, 0, 0), // Start color
      Color.fromARGB(255, 34, 32, 46), // Middle color
      Color.fromARGB(255, 0, 0, 0), // End color
    ],
    stops: [0.0, 0.7, 1.0], // Match stops from Figma
    begin: Alignment.topCenter, // Adjust as needed
    end: Alignment.bottomCenter, // Adjust as needed
  );
  static const LinearGradient buttonColor = LinearGradient(
      colors: [
        Color(0xFFF0AC6E), // Start color from your Figma
        Color(0xFFE3B967), // End color from your Figma
      ],
      stops: [
        0.0,
        1.0
      ], // Stops from your Figma (0% and 100%)
      begin:
          Alignment.centerLeft, // Adjust the position as it was originaed how
      end: Alignment.centerRight);
  static const LinearGradient timerColor = LinearGradient(
      colors: [
        Color(0xFFAC7943), // Start color from your Figma
        Color(0xFFF7C895), // End color from your Figma
      ],
      stops: [
        0.0,
        1.0
      ], // Stops from your Figma (0% and 100%)
      begin:
          Alignment.bottomCenter, // Adjust the position as it was originaed how
      end: Alignment.topCenter);
  static const LinearGradient todoColor1 = LinearGradient(
      colors: [
        Color(0x26FF7DC2), // Start color from your Figma
        Color(0x26E3B967), // End color from your Figma
      ],
      stops: [
        0.0,
        1.0
      ], // Stops from your Figma (0% and 100%)
      begin:
          Alignment.centerLeft, // Adjust the position as it was originaed how
      end: Alignment.centerRight);
  static const LinearGradient todoColor2 = LinearGradient(
      colors: [
        Color(0x268679FE), // Start color from your Figma
        Color(0x26FF7DC2), // End color from your Figma
      ],
      stops: [
        0.0,
        1.0
      ], // Stops from your Figma (0% and 100%)
      begin:
          Alignment.centerLeft, // Adjust the position as it was originaed how
      end: Alignment.centerRight);
}
