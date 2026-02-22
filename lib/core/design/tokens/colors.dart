import 'package:flutter/material.dart';

class SystemColors {
  SystemColors({
    required this.primary,
    required this.secondary,
    required this.titles,
    required this.paragraph,
    required this.background,
    required this.inputBorder,
    required this.inputPlaceholder,
    required this.inactiveButton,
    required this.iconPlaceholder,
  });

  Color primary;
  Color secondary;
  Color titles;
  Color paragraph;
  Color background;
  Color inputBorder;
  Color inputPlaceholder;
  Color inactiveButton;
  Color iconPlaceholder;

  final gradientPrimary = const [Color(0xFF30D299), Color(0xFF12B4A7)];
  final gradientSecondary = const [Color(0xFFF88d49), Color(0xFFF16977)];
  final gradientOrange = const [Color(0xFFF7C119), Color(0xFFF7A036)];
  final gradientGrey = const [Color(0xFF808080), Color(0xFFABABAB)];
  final gradientPurple = const [Color(0xFFBD76F5), Color(0xFFE73D97)];
  final gradientBlue = const [Color(0xFF4D9FF7), Color(0xFF00AFD3)];
  final gradientGreen = const [Color(0xFF3BDB78), Color(0xFF00B577)];
  final gradientYellow = const [Color(0xFFFAC506), Color(0xFFF96C03)];
  final gradientViolet = const [Color(0xFF7A83F8), Color(0xFFA04AF6)];
  final gradientMagenta = const [Color(0xFFF7666A), Color(0xFFEB3C90)];
  final gradientInactive = const [Color(0xFFC6C6C6), Color(0xFFE6E6E6)];

  final aquamarine = const Color(0xFF12B4A7);
  final green = const Color(0xFF28BD65);
  final yellow = const Color(0xFFF7DA40);
  final orange = const Color(0xFFF96C03);
  final red = const Color(0xFFF16977);
  final purple = const Color(0xFFBD76F5);
  final blue = const Color(0xFF4D9FF7);

  final white = const Color(0xFFFFFFFF);
  final whiteSmoke = const Color(0xFFF5F5F5);
  final black = const Color(0xFF000000);
  final grey = const Color(0xFF808080);
  final greyLight = const Color(0xFFABABAB);

  final error = const Color(0xFF721C24);
  final backgroundError = const Color(0xFFF8D7DA);

  final success = const Color(0xFF155724);
  final backgroundSuccess = const Color(0xFFD4EDDA);

  final info = const Color(0xFF0C5460);
  final backgroundInfo = const Color(0xFFD1ECF1);

  final warning = const Color(0xFF856404);
  final backgroundWarning = const Color(0xFFFFF3CD);
}

SystemColors colors = lightColors;

final SystemColors lightColors = SystemColors(
  primary: const Color(0xFF30D299),
  secondary: const Color(0xFFF16977),
  titles: const Color(0xFF000000),
  paragraph: const Color(0xFF808080),
  background: const Color(0xFFFFFFFF),
  inputBorder: const Color(0xFFD4D4D4),
  inputPlaceholder: const Color(0xFFFAFAFA),
  inactiveButton: const Color(0xFFC2C2C2),
  iconPlaceholder: const Color(0xFF9A9A9A),
);

final SystemColors darkColors = SystemColors(
  primary: const Color(0xFF30D299),
  secondary: const Color(0xFFF16977),
  titles: const Color(0xFFFFFFFF),
  paragraph: const Color(0xFFE2E2E2),
  background: const Color(0xFF000000),
  inputBorder: const Color(0xFFD4D4D4),
  inputPlaceholder: const Color(0xFFFAFAFA),
  inactiveButton: const Color(0xFFC2C2C2),
  iconPlaceholder: const Color(0xFF9A9A9A),
);
