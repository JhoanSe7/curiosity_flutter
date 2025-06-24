import 'package:flutter/material.dart';

class SystemColors {
  SystemColors({
    required this.principal,
    required this.titles,
    required this.background,
  });

  Color principal;
  Color titles;
  Color background;
}

SystemColors colors = lightColors;

final SystemColors lightColors = SystemColors(
  principal: const Color(0xFF39CD29),
  titles: const Color(0xFF000000),
  background: const Color(0xFFFFFFFF),
);

final SystemColors darkColors = SystemColors(
  principal: const Color(0xFF39CD29),
  titles: const Color(0xFFFFFFFF),
  background: const Color(0xFF000000),
);
