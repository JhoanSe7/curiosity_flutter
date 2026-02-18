import 'package:curiosity_flutter/core/constants/path_icons.dart';
import 'package:curiosity_flutter/core/design/design.dart';
import 'package:flutter/material.dart';

class GenericLogo extends StatelessWidget {
  final double? size;
  final double? complementSize;
  final bool complementOut;

  const GenericLogo({
    super.key,
    this.size,
    this.complementSize,
    this.complementOut = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(complementOut ? 6 : 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: colors.purple.withValues(alpha: .2),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(4),
                  child: CustomSvg(
                    icons.brain,
                    size: size ?? 40,
                    color: colors.purple,
                  ),
                ),
                if (!complementOut)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: colors.yellow),
                      child: CustomSvg(
                        icons.star,
                        size: complementSize ?? 14,
                        color: colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (complementOut)
          Positioned(
            right: 0,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.yellow,border: Border.all(color: colors.greyLight.withValues(alpha: .5))
              ),
              child: CustomSvg(
                icons.star,
                size: complementSize ?? 14,
                color: colors.grey,
              ),
            ),
          ),
      ],
    );
  }
}
