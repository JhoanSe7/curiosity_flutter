import 'package:curiosity_flutter/core/design/tokens/colors.dart';
import 'package:flutter/material.dart';

class QuestionTimer extends StatefulWidget {
  final int indexQuestion;
  final int timeLimit;
  final VoidCallback? onTimeFinished;

  const QuestionTimer({
    super.key,
    required this.indexQuestion,
    required this.timeLimit,
    this.onTimeFinished,
  });

  @override
  State<QuestionTimer> createState() => _QuestionTimerState();
}

class _QuestionTimerState extends State<QuestionTimer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.timeLimit),
    );

    _colorAnimation = TweenSequence<Color?>([
      TweenSequenceItem(
        tween: ColorTween(begin: colors.white, end: colors.yellow),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: colors.yellow, end: colors.orange),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: colors.orange, end: colors.red),
        weight: 30,
      ),
    ]).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onTimeFinished?.call();
      }
    });

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant QuestionTimer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.indexQuestion != widget.indexQuestion) {
      _controller
        ..duration = Duration(seconds: widget.timeLimit)
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return LinearProgressIndicator(
          value: _controller.value,
          minHeight: 5,
          backgroundColor: Colors.white.withValues(alpha: .3),
          valueColor: AlwaysStoppedAnimation(_colorAnimation.value),
        );
      },
    );
  }
}
