import 'package:curiosity_flutter/core/constants/path_animations.dart';
import 'package:curiosity_flutter/core/constants/path_icons.dart';
import 'package:curiosity_flutter/core/design/atoms/custom_gesture_detector.dart';
import 'package:curiosity_flutter/core/design/atoms/custom_text.dart';
import 'package:curiosity_flutter/core/design/molecules/custom_button.dart';
import 'package:curiosity_flutter/core/design/templates/custom_page_builder.dart';
import 'package:curiosity_flutter/core/design/tokens/colors.dart';
import 'package:curiosity_flutter/core/design/tokens/styles.dart';
import 'package:curiosity_flutter/core/utils/extensions/dimension_extension.dart';
import 'package:curiosity_flutter/features/lobbie/data/models/lobby_player_model.dart';
import 'package:curiosity_flutter/features/lobbie/presentation/lobby/lobby_controller.dart';
import 'package:curiosity_flutter/features/lobbie/presentation/lobby/lobby_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LobbyScreen extends ConsumerStatefulWidget {
  final String roomCode;
  final String userId;
  final String firstName;
  final String? secondName;
  final String lastName;
  final String? secondLastName;
  final String email;
  final String phoneNumber;
  final String role;

  const LobbyScreen({
    super.key,
    required this.roomCode,
    required this.userId,
    required this.firstName,
    this.secondName,
    required this.lastName,
    this.secondLastName,
    required this.email,
    required this.phoneNumber,
    required this.role,
  });

  @override
  ConsumerState<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends ConsumerState<LobbyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(lobbyController.notifier).joinLobby(
            roomCode: widget.roomCode,
            userId: widget.userId,
            firstName: widget.firstName,
            secondName: widget.secondName,
            lastName: widget.lastName,
            secondLastName: widget.secondLastName,
            email: widget.email,
            phoneNumber: widget.phoneNumber,
            role: widget.role,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(lobbyController);

    // Navegar cuando el quiz inicia
    ref.listen<LobbyState>(lobbyController, (_, next) {
      if (next.quizStarted) {
        // TODO: navegar a la pantalla del quiz
      }
    });

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          ref.read(lobbyController.notifier).leaveLobby(
                userId: widget.userId,
                firstName: widget.firstName,
                lastName: widget.lastName,
                email: widget.email,
                phoneNumber: widget.phoneNumber,
                role: widget.role,
              );
        }
      },
      child: CustomPageBuilder(
        title: state.isConnecting ? '' : (state.quizTitle ?? ''),
        enableAppbar: true,
        enableScrollable: false,
        customAppbar: Skeletonizer(
            enabled: state.isConnecting,
            justifyMultiLineText: true,
            child: _LobbyHeader(roomCode: widget.roomCode, quizTitle: state.quizTitle ?? '')),
        body: state.errorMessage != null
            ? _ErrorView(message: state.errorMessage!)
            : Skeletonizer(
                enabled: state.isConnecting,
                child: _LobbyBody(
                  roomCode: widget.roomCode,
                  quizTitle: state.quizTitle ?? 'Cargando quiz...',
                  players: state.isConnecting
                      ? _fakePlayers() // Lista falsa para el skeleton
                      : state.players,
                ),
              ),
      ),
    );
  }

  List<LobbyPlayerModel> _fakePlayers() {
    return List.generate(
      4,
      (i) => LobbyPlayerModel(
        userId: 'fake_$i',
        fullName: 'Jugador $i',
        email: 'FAKE@GMAIL.COM',
        phoneNumber: '0000000000',
        role: 'STUDENT',
        initials: 'J$i',
      ),
    );
  }
}

// ─── Widgets ──────────────────────────────────────────────────────────────────

class _LobbyBody extends StatelessWidget {
  final String roomCode;
  final String quizTitle;
  final List<LobbyPlayerModel> players;

  const _LobbyBody({
    required this.roomCode,
    required this.quizTitle,
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: colors.whiteSmoke,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TeacherWait(),
                _ParticipantsHeader(count: players.length),
                Expanded(
                  child: ListView.separated(
                    itemCount: players.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) => _PlayerTile(player: players[i]),
                  ),
                ),
              ],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: CustomGestureDetector(
              child: SizedBox(
                width: context.width * .95,
                height: 50,
                child: CustomButton(
                  text: "Salir de la sala",
                  fontSize: 18,
                  color: colors.red,
                  onTap: () => context.pop(),
              
                ),
              ),
            ),
          )
        ),
      ],
    );
  }
}

class _LobbyHeader extends StatelessWidget {
  final String roomCode;
  final String quizTitle;

  const _LobbyHeader({required this.roomCode, required this.quizTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: LinearGradient(colors: colors.gradientPrimary)),
      child: Column(
        children: [
          SizedBox(
            width: context.width,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomGestureDetector(
                      onTap: () => context.pop(),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(Icons.arrow_back, size: 24, color: colors.white)),
                      ),
                    ),
                    Column(
                      children: [
                        height.xl,
                        CustomText(
                          quizTitle.isNotEmpty ? quizTitle : '¡Esta sala se nos escapó!',
                          color: colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: CustomText(
                                    'Código:  ',
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: CustomText(
                                    roomCode,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        height.m,
                      ],
                    ),
                    Lottie.asset(animations.pulseDot, width: 32),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: context.width,
            height: 20,
            decoration: BoxDecoration(
              color: colors.whiteSmoke,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: SizedBox(height: 20),
          )
        ],
      ),
    );
  }
}

class _ParticipantsHeader extends StatelessWidget {
  final int count;

  const _ParticipantsHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(children: [
            Icon(Icons.people_outline, size: 20),
            SizedBox(width: 8),
            CustomText(
              'Participantes',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ]),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colors.green.withValues(alpha: .2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomText(
              '$count',
              color: colors.green.withValues(alpha: .8),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerTile extends StatelessWidget {
  final LobbyPlayerModel player;

  const _PlayerTile({required this.player});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: context.width * .95,
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.white, width: 1),
          boxShadow: [
            BoxShadow(
              color: colors.greyLight.withValues(alpha: .3),
              offset: const Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: ListTile(
          leading: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
              gradient: _gradientFromInitials(player.initials)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomText(
                player.initials,
                color: colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          title: CustomText(
            player.fullName,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            textAlign: TextAlign.start,
          ),
          subtitle: Row(children: [
            const Icon(Icons.email_outlined, size: 14, color: Colors.grey),
            const SizedBox(width: 4),
            CustomText(
              player.email,
              fontSize: 12,
              color: colors.paragraph,
              textAlign: TextAlign.start,
            ),
          ]),
        ),
      ),
    );
  }

  LinearGradient _gradientFromInitials(String initials) {
    const gradientPairs = [
      [Colors.teal, Colors.cyan],
      [Colors.orange, Colors.deepOrange],
      [Colors.purple, Colors.indigo],
      [Colors.blue, Colors.lightBlue],
      [Colors.red, Colors.pink],
      [Colors.green, Colors.lime],
    ];
    final index = initials.isNotEmpty ? initials.codeUnitAt(0) % gradientPairs.length : 0;
    final pair = gradientPairs[index];
    return LinearGradient(
      colors: [pair[0], pair[1]],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}

class _TeacherWait extends StatelessWidget {
  const _TeacherWait({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: context.width * .95,
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.white, width: 1),
          boxShadow: [
            BoxShadow(
              color: colors.greyLight.withValues(alpha: .3),
              offset: const Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: colors.gradientOrange),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        icons.king,
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(colors.white, BlendMode.srcIn),
                      ))),
              width.l,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    'Esperando al profesor . . .',
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
              const Spacer(),
              Lottie.asset(animations.loadingSmaller, width: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            height.l,
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Lottie.asset(animations.emptySearch, width: 250),
            ),
            height.l,
            CustomText(message, fontType: FontType.h3, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
