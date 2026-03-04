import 'package:curiosity_flutter/core/utils/utils.dart';
import 'package:flutter/services.dart';

class InputFilters {
  static List<TextInputFormatter> text({int inputLength = 64}) {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZñÑ \s]')),
      LengthLimitingTextInputFormatter(inputLength),
    ];
  }

  static List<TextInputFormatter> numeric({int inputLength = 64}) {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(inputLength),
    ];
  }

  static List<TextInputFormatter> email({int inputLength = 64}) {
    return [
      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9._@!¡#$%&*+-/='¿?^`{|}~]")),
      FilteringTextInputFormatter.deny('[\\S]'),
      LengthLimitingTextInputFormatter(inputLength)
    ];
  }

  static List<TextInputFormatter> passwd({int inputLength = 64}) {
    return [
      FilteringTextInputFormatter.deny('[\\S]'),
      LengthLimitingTextInputFormatter(inputLength),
    ];
  }

  static List<TextInputFormatter> alphaNumeric({int inputLength = 64, bool allowSpace = true, bool uppercase = false}) {
    return [
      FilteringTextInputFormatter.allow(RegExp(allowSpace ? r'[a-zA-ZñÑ0-9 \s]' : r'[a-zA-ZñÑ0-9]')),
      LengthLimitingTextInputFormatter(inputLength),
      if (uppercase) UpperInputFormatter(),
    ];
  }

  static List<TextInputFormatter> cellphone({int inputLength = 12}) {
    return [
      PhoneFormatter(),
      LengthLimitingTextInputFormatter(inputLength),
    ];
  }

  static List<TextInputFormatter> defaultText({int inputLength = 254}) {
    return [LengthLimitingTextInputFormatter(inputLength)];
  }
}
