import 'package:curiosity_flutter/core/constants/config.dart';
import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/utils/extensions/dimension_extension.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:flutter/material.dart';

class UserCardWidget extends StatelessWidget {
  const UserCardWidget(
    this.index,
    this.user, {
    super.key,
    this.identifier = "",
    this.position = 0,
    this.scored = false,
  });

  final int index;
  final UserModel user;
  final String identifier;
  final bool scored;
  final int position;

  @override
  Widget build(BuildContext context) {
    var email = (user.firstName ?? "");
    var initials = email.isNotEmpty && email.length > 2 ? email.toUpperCase().substring(0, 2) : "A1";
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: colors.greyLight.withValues(alpha: .3), offset: Offset(0, 2), blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          if (scored && position > 3) ...[
            CustomText(
              "$position",
              fontSize: 14,
              color: colors.paragraph,
              fontWeight: FontWeight.w600,
            ),
            width.m,
          ],
          scored ? scoreAvatar(context, initials, position) : squareAvatar(context, initials),
          width.l,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  user.fullName(),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  textAlign: TextAlign.start,
                ),
                if (scored && position <= 3)
                  CustomText(
                    "$position° lugar",
                    fontSize: 12,
                    color: colors.paragraph,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.start,
                  )
                else if (!scored)
                  Row(
                    children: [
                      CustomIcon(Icons.email_outlined, size: 14, color: Colors.grey),
                      width.s,
                      CustomText(
                        user.email ?? "",
                        fontSize: 12,
                        color: colors.paragraph,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                if (!scored && (user.quizStatus ?? "").isNotEmpty) ...[
                  height.s,
                  userStatus(),
                ],
              ],
            ),
          ),
          width.l,
          if (!scored && user.email == identifier) ...[
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(shape: BoxShape.circle, color: colors.backgroundWarning),
              child: CustomText(
                "Yo",
                fontSize: 14,
                color: colors.warning,
              ),
            ),
            width.m,
          ] else if (scored) ...[
            Container(
              padding: EdgeInsets.all(4),
              constraints: BoxConstraints(minWidth: 80),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: CustomText(
                "${(user.score ?? 0).toInt()} pts",
                fontSize: 14,
                color: colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget squareAvatar(BuildContext context, String initials) {
    return Container(
      alignment: Alignment.center,
      width: context.scale(45),
      height: context.scale(45),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: Config.allColors[index % Config.allColors.length],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CustomText(
        initials,
        color: colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

  Widget scoreAvatar(BuildContext context, String initials, int position) {
    return Stack(
      children: [
        Container(
          margin: position <= 3 ? EdgeInsets.only(right: 8, bottom: 4) : EdgeInsets.zero,
          alignment: Alignment.center,
          width: context.scale(45),
          height: context.scale(45),
          decoration: BoxDecoration(
            color: (position <= 3 ? topColor(position) : Config.allColors[index % Config.allColors.length].first)
                .withValues(alpha: .2),
            shape: BoxShape.circle,
          ),
          child: CustomText(
            initials,
            color: colors.paragraph,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        if (position <= 3)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: topColor(position),
                shape: BoxShape.circle,
              ),
              child: CustomText(
                "$position",
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colors.white,
                height: 1,
              ),
            ),
          ),
      ],
    );
  }

  Widget userStatus() {
    var color = _getColorStatus(user.quizStatus ?? "");
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: CustomText(
        _getUserStatus(user.quizStatus ?? ""),
        color: color,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    );
  }

  String _getUserStatus(String status) {
    var data = {
      "IN_PROGRESS": "En curso",
      "FINISHED": "Finalizado",
      "ABANDONED": "Abandonado",
    };
    return data[status] ?? "";
  }

  Color _getColorStatus(String status) {
    var data = {
      "IN_PROGRESS": colors.blue,
      "FINISHED": colors.green,
      "ABANDONED": colors.red,
    };
    return data[status] ?? colors.orange;
  }

  Color topColor(int position) {
    var data = {
      1: colors.scoreGold,
      2: colors.scoreSilver,
      3: colors.scoreBronze,
    };
    return data[position] ?? colors.paragraph;
  }
}
