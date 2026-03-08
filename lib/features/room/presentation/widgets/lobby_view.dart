import 'package:curiosity_flutter/core/constants/path_animations.dart';
import 'package:curiosity_flutter/core/constants/path_icons.dart';
import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:curiosity_flutter/features/room/presentation/room_controller.dart';
import 'package:curiosity_flutter/features/room/presentation/widgets/participants_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';

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

  List<List<Color>> allColors = [
    colors.gradientBlue,
    colors.gradientGreen,
    colors.gradientViolet,
    colors.gradientOrange,
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadData);
  }

  _loadData() {
    user = ref.read(homeController).user ?? UserModel();
    roomCode = ref.read(roomController).roomCode;
    ref.read(roomController.notifier).connect(user, roomCode);
  }

  List<UserModel> get userFakeList => List.generate(
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
            Column(
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
          ],
        ),
      ),
      body: state.errorMessage.isEmpty
          ? errorView(state.errorMessage)
          : Skeletonizer(
              enabled: state.isConnecting,
              child: userList(state.isConnecting ? userFakeList : state.users),
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
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          organizerWait(),
          ParticipantsWidget(users.length),
          Flexible(
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                child: Column(
                  children: users.asMap().entries.map((e) => playerCard(e.key, e.value)).toList(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget organizerWait() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: colors.greyLight.withValues(alpha: .3), offset: Offset(0, 2), blurRadius: 6),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors.gradientOrange),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: SvgPicture.asset(
                icons.king,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(colors.white, BlendMode.srcIn),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                'Esperando al organizador . . .',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.titles,
                textAlign: TextAlign.start,
              ),
              CustomText(
                '¡Paciencia, el quiz comenzará pronto!',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: colors.titles,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Lottie.asset(
            animations.loadingSmaller,
            width: 32,
          ),
        ],
      ),
    );
  }

  Widget playerCard(int index, UserModel user) {
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
              (user.firstName ?? "").substring(0, 2),
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

  _onExit() {
    ref.read(roomController.notifier).userLeave(user, roomCode);
    context.pop();
  }
}
