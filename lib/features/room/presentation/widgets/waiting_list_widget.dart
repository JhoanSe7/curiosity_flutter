import 'package:curiosity_flutter/core/constants/path_animations.dart';
import 'package:curiosity_flutter/core/constants/path_icons.dart';
import 'package:curiosity_flutter/core/design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class WaitingListWidget extends StatelessWidget {
  const WaitingListWidget({super.key, required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: colors.greyLight.withValues(alpha: .3), offset: Offset(0, 2), blurRadius: 6),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors.gradientOrange),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: SvgPicture.asset(
                icons.king,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(colors.white, BlendMode.srcIn),
              ),
            ),
          ),
          width.l,
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.titles,
                  textAlign: TextAlign.start,
                ),
                CustomText(
                  text,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: colors.titles,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Lottie.asset(
            animations.loadingSmaller,
            width: 32,
          ),
        ],
      ),
    );
  }
}
