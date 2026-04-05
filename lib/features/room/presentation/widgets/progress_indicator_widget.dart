import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/utils/extensions/dimension_extension.dart';
import 'package:flutter/material.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({
    super.key,
    required this.score,
    required this.maxScore,
    required this.percentage,
    this.size = 150,
  });

  final double score;
  final double maxScore;
  final String percentage;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              color: colors.purple,
              backgroundColor: colors.inputBorder,
              value: score / maxScore,
              strokeWidth: 16,
            ),
          ),
        ),
        Center(
          child: Container(
            alignment: Alignment.center,
            width: size,
            height: size,
            child: CustomText(
              percentage,
              fontSize: context.isTablet ? 30 : 40,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
