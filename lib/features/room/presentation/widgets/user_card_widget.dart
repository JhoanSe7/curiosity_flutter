import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:flutter/material.dart';

class UserCardWidget extends StatelessWidget {
  UserCardWidget(this.index, this.user, {super.key});

  final int index;
  final UserModel user;

  final List<List<Color>> allColors = [
    colors.gradientBlue,
    colors.gradientGreen,
    colors.gradientViolet,
    colors.gradientOrange,
  ];

  @override
  Widget build(BuildContext context) {
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
          Container(
            alignment: Alignment.center,
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: allColors[index % allColors.length],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomText(
              (user.email ?? "").toUpperCase().substring(0, 2),
              color: colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          width.l,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                user.firstName ?? "",
                fontWeight: FontWeight.w600,
                fontSize: 14,
                textAlign: TextAlign.start,
              ),
              Row(
                children: [
                  Icon(Icons.email_outlined, size: 14, color: Colors.grey),
                  width.s,
                  CustomText(
                    user.email ?? "",
                    fontSize: 12,
                    color: colors.paragraph,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
