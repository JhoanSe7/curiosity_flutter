import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/utils/extensions/dimension_extension.dart';
import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget>? additionalWidget;
  final List<Color>? decorationColor;

  const CustomHeader({
    super.key,
    this.title = "",
    this.subtitle = "",
    this.additionalWidget,
    this.decorationColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors.principal,
        ),
      ),
      child: Column(
        children: [
          styles.h(Size.xl),
          Stack(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(6, 12, 8, 4),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: colors.secondary,
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
                    gradient: LinearGradient(colors: colors.tertiary),
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
                    color: colors.mainGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: colors.greyLight, offset: Offset(0, -3), blurRadius: 10),
                    ],
                  ),
                  child: Icon(Icons.blur_circular, color: colors.white, size: 14),
                ),
              )
            ],
          ),
          if (title.isNotEmpty) ...[
            styles.h(Size.l),
            CustomText(
              title,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: colors.white,
            ),
          ],
          if (subtitle.isNotEmpty) ...[
            styles.h(Size.l),
            CustomText(
              subtitle,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: colors.white,
            ),
          ],
          ...additionalWidget ?? [],
          styles.h(Size.xl),
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
                styles.h(Size.xl),
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: decorationColor ?? colors.secondary),
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
