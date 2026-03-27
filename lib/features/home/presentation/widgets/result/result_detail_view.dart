import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/utils/extensions/text_extension.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:curiosity_flutter/features/room/presentation/widgets/detail_answer_widget.dart';
import 'package:curiosity_flutter/features/room/presentation/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResultDetailView extends ConsumerStatefulWidget {
  const ResultDetailView({super.key});

  @override
  ConsumerState<ResultDetailView> createState() => _ResultDetailViewState();
}

class _ResultDetailViewState extends ConsumerState<ResultDetailView> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeController);
    return CustomPageBuilder(
      title: "Resultados del quiz",
      appbarColor: colors.gradientViolet,
      body: Column(
        children: [
          height.l,
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                height.l,
                ProgressIndicatorWidget(
                  score: (state.resultSelected?.totalScore ?? 1),
                  maxScore: (state.resultSelected?.maxPossibleScore ?? 1),
                  percentage: "${(state.resultSelected?.percentage ?? 0).toInt()}%",
                ),
                height.xl,
                CustomText(
                  state.resultSelected?.quizTitle ?? "",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
                height.l,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        (state.resultSelected?.submittedAt ?? "").customDate,
                        fontSize: 16,
                        color: colors.paragraph,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                      CustomText(
                        "# Sala: ${state.resultSelected?.roomCode ?? ""}",
                        fontSize: 16,
                        color: colors.paragraph,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                height.xl,
                CustomText(
                  "${(state.resultSelected?.totalScore ?? 0).toInt()} pts",
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
                CustomText(
                  "de ${(state.resultSelected?.maxPossibleScore ?? 0).toInt()} posibles",
                  fontSize: 14,
                  color: colors.paragraph,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          height.l,
          Row(
            children: [
              answerBox(Icons.check, "Correctas", "${state.resultSelected?.correctAnswers ?? 0}", colors.green),
              width.l,
              answerBox(Icons.close, "Incorrectas", "${state.resultSelected?.incorrectAnswers ?? 0}", colors.red),
            ],
          ),
          height.xl,
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: DetailAnswerWidget(details: state.resultSelected?.details ?? []),
          )
        ],
      ),
    );
  }

  Widget answerBox(IconData icon, String text, String value, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: .2),
                shape: BoxShape.circle,
              ),
              child: CustomIcon(icon, size: 24, color: color),
            ),
            width.m,
            Flexible(
              child: Column(
                children: [
                  CustomText(value, fontSize: 18, fontWeight: FontWeight.w600),
                  CustomText(
                    text,
                    fontSize: 12,
                    color: colors.paragraph,
                    overflow: TextOverflow.ellipsis,
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
