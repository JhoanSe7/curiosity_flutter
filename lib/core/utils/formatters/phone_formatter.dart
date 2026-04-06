import 'package:flutter/services.dart';

class PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newDigits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final buffer = StringBuffer();

    if (newDigits.isNotEmpty) {
      if (newDigits != '3' && newDigits.length == 1) {
        newDigits = '3$newDigits';
      }
      if (newDigits.length <= 3) {
        buffer.write(newDigits);
      } else if (newDigits.length > 3 && newDigits.length <= 6) {
        buffer.write(newDigits.substring(0, 3));
        buffer.write(' ');
        buffer.write(newDigits.substring(3));
      } else {
        buffer.write(newDigits.substring(0, 3));
        buffer.write(' ');
        buffer.write(newDigits.substring(3, 6));
        buffer.write(' ');
        buffer.write(newDigits.substring(6));
      }
    }

    final newText = buffer.toString();
    int newSelectionIndex = newValue.selection.end;
    int diff = newText.length - newValue.text.length;

    if (newText.length == 3 && newValue.text.length > newText.length) {
      newSelectionIndex = 3;
    } else if (diff > 0 && newSelectionIndex >= diff) {
      newSelectionIndex += diff;
    } else if (diff < 0 && newSelectionIndex > 0) {
      newSelectionIndex -= 1;
    } else if (newSelectionIndex > newText.length) {
      newSelectionIndex = newText.length;
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newSelectionIndex),
    );
  }
}
