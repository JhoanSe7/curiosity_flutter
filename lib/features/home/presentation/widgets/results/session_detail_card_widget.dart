import 'package:curiosity_flutter/core/constants/config.dart';
import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/core/utils/extensions/text_extension.dart';
import 'package:curiosity_flutter/features/home/data/models/session_model.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'date_text_widget.dart';

class SessionDetailCardWidget extends StatelessWidget {
  const SessionDetailCardWidget(this.index, this.e, {super.key});

  final int index;
  final SessionModel e;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.inputBorder),
        boxShadow: [
          BoxShadow(color: colors.greyLight.withValues(alpha: .3), offset: Offset(0, 2), blurRadius: 6),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: CustomText(
                  e.quizTitle ?? "",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Consumer(
                builder: (context, ref, _) => CustomButton(
                  height: 6,
                  gradientColor: Config.allColors[index % Config.allColors.length],
                  isGradient: true,
                  onTap: () => _tapDetail(context, ref),
                  text: "Ver detalle",
                ),
              )
            ],
          ),
          Divider(
            indent: 8,
            endIndent: 8,
            height: 40,
          ),
          Row(
            children: [
              CustomIcon(
                Icons.numbers,
                size: 18,
                color: colors.iconPlaceholder,
              ),
              width.s,
              CustomText(
                "${e.roomCode}",
                fontSize: 14,
                color: colors.paragraph,
                fontWeight: FontWeight.w500,
              ),
              width.xl,
              Flexible(child: DateTextWidget(text: (e.submittedAt ?? "").customDate)),
            ],
          ),
          height.m,
          Row(
            children: [
              CustomIcon(
                Icons.groups_outlined,
                size: 18,
                color: colors.iconPlaceholder,
              ),
              width.m,
              CustomText(
                "${e.players?.length ?? 0} participantes",
                fontSize: 14,
                color: colors.paragraph,
                fontWeight: FontWeight.w500,
              )
            ],
          )
        ],
      ),
    );
  }

  void _tapDetail(BuildContext context, WidgetRef ref) {
    ref.read(homeController.notifier).setSessionSelected(e);
    context.push(Routes.sessionResultUser);
  }
}
