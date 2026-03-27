import 'package:curiosity_flutter/core/constants/path_animations.dart';
import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:curiosity_flutter/features/room/presentation/room_controller.dart';
import 'package:curiosity_flutter/features/room/presentation/room_state.dart';
import 'package:curiosity_flutter/features/room/presentation/widgets/participants_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'user_card_widget.dart';
import 'waiting_list_widget.dart';

class LobbyView extends ConsumerStatefulWidget {
  const LobbyView({
    super.key,
  });

  @override
  ConsumerState<LobbyView> createState() => _LobbyViewState();
}

class _LobbyViewState extends ConsumerState<LobbyView> {
  late UserModel user;
  String roomCode = "";
  String identifier = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadData);
  }

  void _loadData() {
    user = ref.read(homeController).user ?? UserModel();
    identifier = user.email ?? "";
    roomCode = ref.read(roomController).roomCode;
    ref.read(roomController.notifier).connect(user, roomCode);
  }

  List<UserModel> get fakeUsers => List.generate(
        4,
        (i) => UserModel(
          id: 'fake_$i',
          firstName: 'Jugador $i',
          email: 'FAKE@GMAIL.COM',
          phoneNumber: '0000000000',
        ),
      );

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(roomController);
    var quizTitle = state.quizTitle;
    ref.listen(roomController, _getQuizAndStart);
    return CustomPageBuilder(
      centerTitle: true,
      enableLeading: false,
      trailing: connectionTick,
      enableScrollable: false,
      secondAppbar: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    quizTitle.isNotEmpty ? quizTitle : '¡Esta sala se nos escapó!',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: colors.white,
                  ),
                  height.m,
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colors.white.withValues(alpha: .3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          'Código:  ',
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                        width.m,
                        CustomText(
                          roomCode,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      body: state.errorMessage.isNotEmpty
          ? errorView(state.errorMessage)
          : Skeletonizer(
              enabled: state.isConnecting,
              child: userList(state.isConnecting ? fakeUsers : state.users),
            ),
      bottomBar: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
        child: CustomButton(
          textColor: colors.red,
          border: Border.all(color: colors.red),
          height: 16,
          color: colors.red.withValues(alpha: .1),
          onTap: _onExit,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIcon(
                Icons.exit_to_app,
                color: colors.red,
                size: 18,
              ),
              width.m,
              CustomText(
                "Salir de la sala",
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget connectionTick = Lottie.asset(animations.pulseDot, width: 32);

  Widget userList(List<UserModel> users) {
    return Column(
      children: [
        WaitingListWidget(
          title: 'Esperando al organizador . . .',
          text: '¡Paciencia, el quiz comenzará pronto!',
        ),
        ParticipantsWidget(users.length),
        Flexible(
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              child: Column(
                children:
                    users.asMap().entries.map((e) => UserCardWidget(e.key, e.value, identifier: identifier)).toList(),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget errorView(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            height.l,
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Lottie.asset(animations.emptySearch, width: 250),
            ),
            height.l,
            CustomText(
              message,
              textAlign: TextAlign.center,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  void _onExit() {
    final controller = ref.read(roomController.notifier);
    controller.emitMsg('/app/lobby.leave/$roomCode', user.toMap());
    controller.clearState();
    context.pop();
  }

  Future<void> _getQuizAndStart(RoomState? previous, RoomState next) async {
    if (previous?.quizStarted != true && next.quizStarted) {
      await ref.read(roomController.notifier).loadQuiz(context, quizId: next.quizId);
      if (mounted) context.pushReplacement(Routes.quizFlow);
    }
  }
}
