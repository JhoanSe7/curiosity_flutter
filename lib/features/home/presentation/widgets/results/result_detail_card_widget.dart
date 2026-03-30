import 'package:curiosity_flutter/core/constants/config.dart';
import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/core/utils/extensions/text_extension.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:curiosity_flutter/features/room/data/models/quiz_result_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ResultDetailCardWidget extends ConsumerWidget {
  const ResultDetailCardWidget(this.index, this.e, {super.key});

  final int index;
  final QuizResultModel e;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomGestureDetector(
      onTap: () => _onTapDetail(context, ref, e),
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: Config.allColors[index % Config.allColors.length],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIcon(
                Icons.book_outlined,
                size: 30,
                color: colors.white,
              ),
            ),
            width.l,
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    e.quizTitle ?? "",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomIcon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: colors.iconPlaceholder,
                      ),
                      width.s,
                      Flexible(
                        child: CustomText(
                          (e.submittedAt ?? "").customDate,
                          fontSize: 14,
                          color: colors.paragraph,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            width.l,
            CustomText(
              "${(e.totalScore ?? 0).toInt()} pts",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.primary,
            ),
            CustomIcon(Icons.chevron_right_outlined, size: 25, color: colors.iconPlaceholder)
          ],
        ),
      ),
    );
  }

  void _onTapDetail(BuildContext context, WidgetRef ref, QuizResultModel e) {
    final controller = ref.read(homeController.notifier);
    controller.setResultDetail(e);
    context.push(Routes.resultDetail);
  }
}
