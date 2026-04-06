import 'dart:math';

import 'package:curiosity_flutter/core/design/atoms/custom_text.dart';
import 'package:curiosity_flutter/core/design/tokens/colors.dart';
import 'package:curiosity_flutter/core/utils/extensions/dimension_extension.dart';
import 'package:flutter/material.dart';

class CountdownOverlayTimer extends StatefulWidget {
  final int time;
  final VoidCallback? onTimeFinished;

  const CountdownOverlayTimer({
    super.key,
    required this.time,
    this.onTimeFinished,
  });

  @override
  State<CountdownOverlayTimer> createState() => _CountdownOverlayTimerState();
}

class _CountdownOverlayTimerState extends State<CountdownOverlayTimer> with TickerProviderStateMixin {
  late AnimationController _countdownController;

  @override
  void initState() {
    super.initState();

    _countdownController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.time),
    );

    _countdownController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onTimeFinished?.call();
      }
    });

    _countdownController.forward();
  }

  @override
  void dispose() {
    _countdownController.dispose();
    super.dispose();
  }

  int get remainingCountdown {
    return max(1, 3 - (_countdownController.value * 3).floor());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _countdownController,
      builder: (_, __) {
        final pulse = 1 + (sin(_countdownController.value * 20) * 0.1);

        return Container(
          color: colors.black.withValues(alpha: .6),
          child: Center(
            child: Transform.scale(
              scale: pulse,
              child: Container(
                  width: context.scale(150),
                  height: context.scale(150),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.red.withValues(alpha: .6),
                  ),
                  alignment: Alignment.center,
                  child: CustomText(
                    "$remainingCountdown",
                    fontSize: 70,
                    fontWeight: FontWeight.w700,
                    color: colors.white,
                  )),
            ),
          ),
        );
      },
    );
  }
}
