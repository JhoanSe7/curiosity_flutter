import 'package:flutter/services.dart';

class UpperInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.toUpperCase();

    return TextEditingValue(
      text: newText,
      selection: newValue.selection,
    );
  }
}
