import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:curiosity_flutter/features/room/presentation/room_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FinishQuiz extends ConsumerStatefulWidget {
  const FinishQuiz({super.key});

  @override
  ConsumerState<FinishQuiz> createState() => _FinishQuizState();
}

class _FinishQuizState extends ConsumerState<FinishQuiz> {
  @override
  Widget build(BuildContext context) {
    return CustomPageBuilder(
      title: "Quiz finalizado",
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CustomText(
              "El quiz ha finalizado, puedes esperar tus resultados o "
              "abandonar y consultarlos mas tarde en la seccion de 'resultados'",
              fontSize: 14,
              color: colors.paragraph,
            )
          ],
        ),
      ),
      bottomBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
        child: CustomButton(
          text: "Terminar",
          large: true,
          onTap: _onFinish,
        ),
      ),
    );
  }

  _onFinish() {
    final controller = ref.read(roomController.notifier);
    var roomCode = ref.read(roomController).roomCode;
    var user = ref.read(homeController).user ?? UserModel();
    controller.emitMsg('/app/lobby.leave/$roomCode', user.toMap());
    controller.clearState();
    context.go(Routes.home);
  }
}
