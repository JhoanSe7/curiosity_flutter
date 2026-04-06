import 'package:flutter/material.dart';

class CustomGestureDetector extends StatelessWidget {
  final Function()? onTap;
  final Widget? child;
  final Color? splashColor;

  const CustomGestureDetector({
    super.key,
    this.onTap,
    this.child,
    this.splashColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
        child: InkWell(
          splashColor: splashColor,
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}
