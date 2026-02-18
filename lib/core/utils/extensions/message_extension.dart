import 'package:curiosity_flutter/core/constants/path_animations.dart';
import 'package:curiosity_flutter/core/design/design.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
    final messenger = ScaffoldMessenger.of(this);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(message);
  }

  void get loading => showDialog(
        context: this,
        barrierDismissible: false,
        builder: (context) => PopScope(
          canPop: false,
          child: Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: EdgeInsets.all(16),
              child: Transform.scale(
                scale: 1.5,
                child: Lottie.asset(animations.brain, fit: BoxFit.cover),
              ),
            ),
          ),
        ),
      );

  Future<void> showModal({
    IconData icon = Icons.info_outline,
    Color iconColor = Colors.cyan,
    required String title,
    required String content,
    Widget? actions,
  }) =>
      showDialog(
        context: this,
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 35,
                  ),
                ),
                height.xl,
                CustomText(title, fontWeight: FontWeight.w700, fontSize: 20),
                height.m,
                CustomText(content),
                height.xl,
                actions ?? CustomButton(text: "Entendido"),
              ],
            ),
          ),
        ),
      );
}
