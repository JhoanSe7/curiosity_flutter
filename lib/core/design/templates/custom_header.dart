import 'package:curiosity_flutter/core/constants/path_icons.dart';
import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/utils/extensions/dimension_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget>? additionalWidget;
  final List<Color>? decorationColor;
  final bool enableLeading;

  const CustomHeader({
    super.key,
    this.title = "",
    this.subtitle = "",
    this.additionalWidget,
    this.decorationColor,
    this.enableLeading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors.gradientPrimary,
        ),
      ),
      child: Column(
        children: [
          if (enableLeading)
            CustomGestureDetector(
              onTap: context.pop,
              child: Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.all(8),
                child: CustomIcon(
                  Icons.arrow_back,
                  size: 30,
                  color: colors.white,
                ),
              ),
            )
          else
            height.l,
          Stack(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(6, 12, 8, 4),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: colors.gradientSecondary,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: colors.grey, offset: Offset(0, 3), blurRadius: 10),
                  ],
                ),
                child: CustomSvg(icons.brain, size: 35),
              ),
              Positioned(
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: colors.gradientOrange),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: colors.greyLight, offset: Offset(0, 3), blurRadius: 10),
                    ],
                  ),
                  child: CustomSvg(icons.star, size: 16),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: colors.greyLight, offset: Offset(0, -3), blurRadius: 10),
                    ],
                  ),
                  child: CustomIcon(Icons.blur_circular, color: colors.white, size: 14),
                ),
              )
            ],
          ),
          if (title.isNotEmpty) ...[
            height.l,
            CustomText(
              title,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: colors.white,
            ),
          ],
          if (subtitle.isNotEmpty) ...[
            height.l,
            CustomText(
              subtitle,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: colors.white,
            ),
          ],
          ...additionalWidget ?? [],
          height.xl,
          Container(
            width: context.width,
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                height.xl,
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: decorationColor ?? colors.gradientSecondary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
