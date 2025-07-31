import 'package:curiosity_flutter/core/design/design.dart';
import 'package:flutter/material.dart';

extension MessageExtension on BuildContext {
  showToast({required String text, bool error = false}) {
    final message = SnackBar(
      backgroundColor: error ? colors.backgroundError : colors.backgroundSuccess,
      showCloseIcon: true,
      closeIconColor: error ? colors.error : colors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      content: CustomText(
        text,
        color: error ? colors.error : colors.success,
      ),
    );
    ScaffoldMessenger.of(this).showSnackBar(message);
  }
}
