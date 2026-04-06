import 'package:curiosity_flutter/core/constants/path_animations.dart';
import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/utils/extensions/dimension_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

extension MessageExtension on BuildContext {
  void showToast({required String text, MessageType type = MessageType.info}) {
    final message = SnackBar(
      backgroundColor: _bgColor(type),
      showCloseIcon: true,
      closeIconColor: _color(type),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      content: CustomText(
        text,
        color: _color(type),
        fontSize: 14,
      ),
    );
    final messenger = ScaffoldMessenger.of(this);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(message);
  }

  Color _bgColor(MessageType type) {
    switch (type) {
      case MessageType.success:
        return colors.backgroundSuccess;
      case MessageType.error:
        return colors.backgroundError;
      case MessageType.info:
        return colors.backgroundInfo;
      case MessageType.warning:
        return colors.backgroundWarning;
    }
  }

  Color _color(MessageType type) {
    switch (type) {
      case MessageType.success:
        return colors.success;
      case MessageType.error:
        return colors.error;
      case MessageType.info:
        return colors.info;
      case MessageType.warning:
        return colors.warning;
    }
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

  Future showModal({
    IconData icon = Icons.info_outline,
    Color? iconColor,
    Color? buttonColor,
    double widthContainer = 1,
    required String title,
    required String content,
    Widget? actions,
    bool showClose = false,
    double? closeSize,
    void Function()? onTap,
  }) async =>
      await showDialog(
        context: this,
        builder: (context) => Center(
          child: Container(
            width: context.width * widthContainer,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showClose)
                  Align(
                    alignment: Alignment.topRight,
                    child: CustomCircularButton(
                      color: colors.primary,
                      icon: Icons.cancel,
                      size: closeSize,
                      onTap: () => context.pop(),
                    ),
                  ),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (iconColor ?? colors.primary).withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: CustomIcon(
                    icon,
                    color: iconColor ?? colors.primary,
                    size: 35,
                  ),
                ),
                height.xl,
                CustomText(title, fontWeight: FontWeight.w700, fontSize: 20),
                height.m,
                CustomText(
                  content,
                  fontSize: 14,
                ),
                height.xl,
                actions ??
                    CustomButton(
                      text: "Entendido",
                      color: buttonColor ?? colors.primary,
                      height: 14,
                      onTap: onTap ?? () => context.pop(true),
                    ),
              ],
            ),
          ),
        ),
      );

  Future showBottomSheetModal({required String title, required Widget child}) async => await showModalBottomSheet(
        context: this,
        builder: (_) => Container(
          padding: EdgeInsets.all(16),
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _bottomSheetHeader(title),
                  height.m,
                  Divider(),
                  height.m,
                  child,
                ],
              ),
            ),
          ),
        ),
      );

  Widget _bottomSheetHeader(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: CustomCircularButton(
            icon: Icons.close,
            color: colors.grey,
            onTap: () => pop(),
          ),
        )
      ],
    );
  }
}

enum MessageType {
  success,
  error,
  info,
  warning,
}
