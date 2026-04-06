import 'package:curiosity_flutter/core/design/tokens/colors.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final bool active;
  final Function onChange;
  final double? height;
  final double? width;
  final Color? colorActive;
  final Color? colorBackground;

  const CustomSwitch({
    super.key,
    required this.active,
    required this.onChange,
    this.height,
    this.width,
    this.colorActive,
    this.colorBackground,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) => onChange(),
      onTap: () => onChange(),
      child: Stack(alignment: Alignment.center, children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: active ? (colorActive ?? colors.primary) : (colorBackground ?? colors.inactiveButton),
          ),
          height: height ?? 28,
          width: width ?? 48,
          padding: EdgeInsets.all(4),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          left: active ? 20 : 4,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            child: active
                ? Icon(Icons.check, size: 16, color: colorActive ?? colors.primary)
                : Icon(Icons.close, size: 16, color: colorBackground ?? colors.inactiveButton),
          ),
        ),
      ]),
    );
  }
}
