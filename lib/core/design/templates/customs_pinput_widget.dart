import 'package:curiosity_flutter/core/design/tokens/colors.dart';
import 'package:curiosity_flutter/core/design/tokens/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';

class CustomsPinputWidget extends ConsumerStatefulWidget {
  const CustomsPinputWidget({
    super.key,
    required this.onCompleted,
    required this.onChange,
    this.error = false,
  });

  final bool error;
  final void Function(String) onCompleted;
  final void Function(String) onChange;

  @override
  ConsumerState<CustomsPinputWidget> createState() => _CustomsPinputWidgetState();
}

class _CustomsPinputWidgetState extends ConsumerState<CustomsPinputWidget> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  bool showError = false;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: styles.poppins(
        fontSize: 22,
        color: colors.titles,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: widget.error ? colors.error : colors.inputBorder),
      ),
    );

    return SizedBox(
      height: 68,
      child: Pinput(
        length: 6,
        controller: controller,
        focusNode: focusNode,
        defaultPinTheme: defaultPinTheme,
        onCompleted: widget.onCompleted,
        onChanged: widget.onChange,
        focusedPinTheme: defaultPinTheme.copyWith(
          height: 68,
          width: 64,
          decoration: defaultPinTheme.decoration!.copyWith(
            border: Border.all(color: colors.primary),
          ),
        ),
        errorPinTheme: defaultPinTheme.copyWith(
          decoration: BoxDecoration(
            color: colors.backgroundError,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
