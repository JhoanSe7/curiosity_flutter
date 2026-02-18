import 'package:curiosity_flutter/core/design/design.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String subtitle;
  final String title;
  final String desc;
  final IconData icon;
  final List<Color> bgColor;
  final Color color;
  final void Function()? onTap;
  final String tag;
  final Color? tagColor;
  final bool enableShadow;
  final bool enableBorder;

  const CustomCard({
    super.key,
    required this.subtitle,
    required this.title,
    required this.desc,
    required this.icon,
    required this.bgColor,
    required this.color,
    this.onTap,
    this.tag = "",
    this.tagColor,
    this.enableShadow = false,
    this.enableBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomGestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: enableBorder ? color.withValues(alpha: .2) : colors.white, width: 2),
          boxShadow: [
            BoxShadow(color: colors.greyLight.withValues(alpha: .5), offset: Offset(0, 5), blurRadius: 10),
            if (enableShadow) BoxShadow(color: color, offset: Offset(-5, 0)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: bgColor,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(
                icon,
                color: colors.white,
                size: 36,
              ),
            ),
            SizedBox(width: 16),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: .2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CustomText(
                          subtitle,
                          color: color,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      if (tag.isNotEmpty) ...[
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: (tagColor ?? colors.yellow).withValues(alpha: .5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CustomText(
                            tag,
                            color: colors.paragraph.withValues(alpha: .5),
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ]
                    ],
                  ),
                  SizedBox(height: 8),
                  CustomText(
                    title,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 8),
                  CustomText(
                    desc,
                    color: colors.paragraph,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
