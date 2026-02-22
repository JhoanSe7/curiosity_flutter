import 'package:curiosity_flutter/core/constants/path_icons.dart';
import 'package:curiosity_flutter/core/design/design.dart';
import 'package:flutter/material.dart';

class GenericLogo extends StatelessWidget {
  final double? size;
  final double? complementSize;
  final bool complementOut;
  final bool showComplement;
  final Color? logoColor;
  final Color? bgColor;
  final bool isGradient;
  final List<Color> bgGradientColor;
  final double? padding;

  const GenericLogo({
    super.key,
    this.size,
    this.complementSize,
    this.complementOut = false,
    this.showComplement = true,
    this.logoColor,
    this.bgColor,
    this.isGradient = false,
    this.bgGradientColor = const [],
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(complementOut ? 6 : 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isGradient ? null : bgColor ?? colors.purple.withValues(alpha: .2),
            gradient: isGradient
                ? LinearGradient(colors: bgGradientColor, begin: Alignment.topLeft, end: Alignment.bottomRight)
                : null,
          ),
          child: Container(
            padding: EdgeInsets.all(padding ?? 20),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(4),
                  child: CustomSvg(
                    icons.brain,
                    size: size ?? 40,
                    color: logoColor ?? colors.purple,
                  ),
                ),
                if (!complementOut && showComplement)
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
        if (complementOut && showComplement)
          Positioned(
            right: 0,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.yellow,
                border: Border.all(color: colors.greyLight.withValues(alpha: .5)),
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
