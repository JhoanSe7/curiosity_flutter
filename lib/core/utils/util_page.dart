import 'package:flutter/material.dart';

class UtilPage {
  void autoScroll(BuildContext context) {
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

final view = UtilPage();
