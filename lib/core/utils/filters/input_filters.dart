import 'package:flutter/services.dart';

class InputFilters {
  static List<TextInputFormatter> text({int inputLength = 64}) {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZñÑ \s]')),
      LengthLimitingTextInputFormatter(inputLength),
    ];
  }

  static List<TextInputFormatter> email({int inputLength = 64}) {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9._@]')),
      FilteringTextInputFormatter.deny('[\\S]'),
      LengthLimitingTextInputFormatter(inputLength)
    ];
  }
}
