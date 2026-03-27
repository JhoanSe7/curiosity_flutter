import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/features/room/data/models/result_detail_model.dart';
import 'package:curiosity_flutter/features/room/presentation/room_controller.dart';
import 'package:curiosity_flutter/features/room/presentation/room_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FinishQuizView extends ConsumerStatefulWidget {
  const FinishQuizView({super.key});

  @override
  ConsumerState<FinishQuizView> createState() => _FinishQuizViewState();
}

class _FinishQuizViewState extends ConsumerState<FinishQuizView> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(roomController);
    return CustomPageBuilder(
      title: "Resultados",
      enableLeading: false,
      centerTitle: true,
      appbarColor: colors.gradientPurple,
      body: state.waiting ? waitingResults() : showingResults(state),
      bottomBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
        child: CustomButton(
          text: state.waiting ? "Abandonar sala por ahora" : "Finalizar revision",
          textColor: state.waiting ? colors.purple : colors.white,
          large: true,
          height: 16,
          color: state.waiting ? colors.white : colors.purple,
          border: Border.all(color: colors.purple),
          onTap: _onFinish,
        ),
      ),
    );
  }

  void _onFinish() {
    final controller = ref.read(roomController.notifier);
    // var roomCode = ref.read(roomController).roomCode;
    // var user = ref.read(homeController).user ?? UserModel();
    // controller.emitMsg('/app/lobby.leave/$roomCode', user.toMap());
    controller.clearState();
    context.go(Routes.home);
  }

  Widget showingResults(RoomState state) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          height.xl,
          progressIndicator(state),
          height.xl,
          CustomText(
            "¡Buen trabajo!",
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          height.l,
          CustomText(
            "Has completado el quiz exitosamente.",
            fontSize: 14,
            color: colors.paragraph,
          ),
          height.l,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Divider(),
          ),
          height.l,
          statsWidget(state),
          height.l,
          detailAnswers(state)
        ],
      ),
    );
  }

  Widget progressIndicator(RoomState state) {
    double size = 150;
    return Stack(
      children: [
        Center(
          child: SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              color: colors.purple,
              backgroundColor: colors.inputBorder,
              value: (state.results?.totalScore ?? 1) / (state.results?.maxPossibleScore ?? 1),
              strokeWidth: 16,
            ),
          ),
        ),
        Center(
          child: Container(
            alignment: Alignment.center,
            width: size,
            height: size,
            child: CustomText(
              "${(state.results?.percentage ?? 0).toInt()}%",
              fontSize: 40,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }

  Widget statsWidget(RoomState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        statItem("CORRECTAS", "${state.results?.correctAnswers ?? "0"}", colors.green),
        statItem("INCORRECTAS", "${state.results?.incorrectAnswers ?? "0"}", colors.red),
        statItem("PUNTOS", "${(state.results?.totalScore ?? 0).toInt()}", colors.purple),
      ],
    );
  }

  Widget statItem(String text, String value, Color color) {
    return Column(
      children: [
        CustomText(
          value,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: color,
        ),
        CustomText(
          text,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: colors.paragraph,
        ),
      ],
    );
  }

  Widget waitingResults() {
    return Column(
      children: [
        height.xl,
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.purple.withValues(alpha: .1),
            shape: BoxShape.circle,
          ),
          child: CustomIcon(
            Icons.check_circle_outline,
            size: 40,
            color: colors.purple,
          ),
        ),
        height.xl,
        CustomText(
          "¡Quiz completado!",
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        height.l,
        CustomText(
          "Has respondido todas las preguntas.\nTu participacion ha sido guardada exitosamente.",
          fontSize: 14,
          color: colors.paragraph,
        ),
        height.xl,
        Container(
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: colors.white,
            border: Border.all(
              color: colors.inputBorder,
            ),
          ),
          child: Column(
            children: [
              CircularProgressIndicator(
                color: colors.purple,
              ),
              height.l,
              CustomText(
                "Esperando a que el organizador revele los resultados ...",
                fontSize: 14,
                color: colors.purple,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget detailAnswers(RoomState state) {
    var detail = state.results?.details ?? [];
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
          ...detail.map(
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
        message: e.explanation,
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
