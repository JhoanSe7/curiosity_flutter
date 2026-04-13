import 'dart:async';
import 'package:curiosity_flutter/core/design/atoms/custom_text.dart';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final Duration duration;
  final VoidCallback onFinished;

  /// Umbrales (en porcentaje del total)

  const CountdownTimer({
    super.key,
    required this.duration,
    required this.onFinished,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int _remainingSeconds;
  late int _totalSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.duration.inSeconds;
    _totalSeconds = widget.duration.inSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        timer.cancel();
        setState(() {
          _remainingSeconds = 0;
        });
        widget.onFinished();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${secs.toString().padLeft(2, '0')}';
  }

  Color _getColor() {
    final ratio = _remainingSeconds / _totalSeconds;

    if (ratio <= 0.2) {
      return Colors.red;
    } else if (ratio <= 0.5) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return CustomText(
      _formatTime(_remainingSeconds),
      fontSize: 14,
      color: color,
      fontWeight: FontWeight.w600,
    );
  }
}
