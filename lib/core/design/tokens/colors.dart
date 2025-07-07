import 'package:flutter/material.dart';

class SystemColors {
  SystemColors({
    required this.titles,
    required this.paragraph,
    required this.background,
    required this.inputBorder,
    required this.inputPlaceholder,
    required this.inactiveButton,
    required this.iconPlaceholder,
  });

  Color titles;
  Color paragraph;
  Color background;
  Color inputBorder;
  Color inputPlaceholder;
  Color inactiveButton;
  Color iconPlaceholder;

  final principal = const [Color(0xFF30D299), Color(0xFF12B4A7)];
  final secondary = const [Color(0xFFF88d49), Color(0xFFF16977)];
  final tertiary = const [Color(0xFFF7C119), Color(0xFFF7A036)];
  final gradientGrey = const [Color(0xFF808080), Color(0xFFABABAB)];

  final mainGreen = const Color(0xFF30D299);
  final secondGreen = const Color(0xFF12B4A7);
  final yellow = const Color(0xFFF7DA40);

  final white = const Color(0xFFFFFFFF);
  final black = const Color(0xFF000000);
  final grey = const Color(0xFF808080);
  final greyLight = const Color(0xFFABABAB);
}

SystemColors colors = lightColors;

final SystemColors lightColors = SystemColors(
  titles: const Color(0xFF000000),
  paragraph: const Color(0xFF808080),
  background: const Color(0xFFFFFFFF),
  inputBorder: const Color(0xFFD4D4D4),
  inputPlaceholder: const Color(0xFFFAFAFA),
  inactiveButton: const Color(0xFFC2C2C2),
  iconPlaceholder: const Color(0xFF9A9A9A),
);

final SystemColors darkColors = SystemColors(
  titles: const Color(0xFFFFFFFF),
  paragraph: const Color(0xFFE2E2E2),
  background: const Color(0xFF000000),
  inputBorder: const Color(0xFFD4D4D4),
  inputPlaceholder: const Color(0xFFFAFAFA),
  inactiveButton: const Color(0xFFC2C2C2),
  iconPlaceholder: const Color(0xFF9A9A9A),
);
