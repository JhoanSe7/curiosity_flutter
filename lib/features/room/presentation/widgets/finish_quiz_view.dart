import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/features/room/presentation/room_controller.dart';
import 'package:curiosity_flutter/features/room/presentation/room_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'detail_answer_widget.dart';
import 'progress_indicator_widget.dart';

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
          ProgressIndicatorWidget(
            score: (state.results?.totalScore ?? 1),
            maxScore: (state.results?.maxPossibleScore ?? 1),
            percentage: "${(state.results?.percentage ?? 0).toInt()}%",
          ),
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
          DetailAnswerWidget(details: state.results?.details ?? [])
        ],
      ),
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
}
