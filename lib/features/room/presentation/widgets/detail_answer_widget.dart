import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/features/room/data/models/result_detail_model.dart';
import 'package:flutter/material.dart';

class DetailAnswerWidget extends StatelessWidget {
  const DetailAnswerWidget({super.key, required this.details});

  final List<ResultDetailModel> details;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            "Resumen de respuestas",
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          height.l,
          ...details.map(
            (e) => answerAndQuestion(e),
          ),
        ],
      ),
    );
  }

  Widget answerAndQuestion(ResultDetailModel e) {
    var answer = e.answer ?? "";
    var isCorrect = e.isCorrect ?? false;
    var correctAnswer = e.answerCorrect ?? "";
    var incorrectAnswer = e.answerIncorrect ?? "";
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.inputBorder),
      ),
      child: Tooltip(
        message: e.explanation ?? "",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              e.question ?? "",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.left,
            ),
            if (e.questionType == "MULTIPLE_SELECTION") ...[
              if (answer.isNotEmpty) ...[height.m, answerCard(answer, true)],
              if (incorrectAnswer.isNotEmpty) ...[height.m, answerCard(incorrectAnswer, false)],
              if (incorrectAnswer.isEmpty && !isCorrect) ...[height.m, missingAnswerCard(answer, correctAnswer)]
            ] else ...[
              height.m,
              answerCard(answer, isCorrect)
            ],
            if (!isCorrect) ...[
              height.m,
              Container(
                padding: EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    CustomIcon(
                      Icons.info_outline,
                      color: colors.iconPlaceholder,
                      size: 18,
                    ),
                    width.s,
                    Flexible(
                      child: CustomText(
                        "Respuesta correcta: $correctAnswer",
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: colors.paragraph,
                      ),
                    ),
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget answerCard(String answer, bool isCorrect) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: (isCorrect ? colors.green : colors.red).withValues(alpha: .1),
        border: Border.all(color: isCorrect ? colors.green : colors.red),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CustomIcon(
            isCorrect ? Icons.check_circle_outline : Icons.cancel_outlined,
            color: isCorrect ? colors.green : colors.red,
            size: 24,
          ),
          width.m,
          Flexible(
            child: CustomText(
              answer.isEmpty ? "(Sin respuesta)" : answer,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isCorrect ? colors.green : colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget missingAnswerCard(String answer, String correctAnswer) {
    List<String> answerList = answer.split(", ");
    List<String> correctList = correctAnswer.split(", ");
    List<String> diff = correctList.where((e) => !answerList.contains(e)).toList();
    String missing = diff.isNotEmpty ? diff.join(", ") : "";

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colors.inputPlaceholder,
        border: Border.all(color: colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CustomIcon(
            Icons.circle_outlined,
            color: colors.iconPlaceholder,
            size: 24,
          ),
          width.m,
          Flexible(
            child: CustomText(
              missing,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colors.iconPlaceholder,
            ),
          ),
        ],
      ),
    );
  }
}
