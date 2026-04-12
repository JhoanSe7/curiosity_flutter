import 'package:curiosity_flutter/core/constants/config.dart';
import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/utils/extensions/message_extension.dart';
import 'package:curiosity_flutter/core/utils/util_page.dart';
import 'package:curiosity_flutter/features/room/presentation/room_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'users_scored_list_widget.dart';

class ScoredBoardView extends ConsumerStatefulWidget {
  const ScoredBoardView({super.key});

  @override
  ConsumerState<ScoredBoardView> createState() => _ScoredBoardViewState();
}

class _ScoredBoardViewState extends ConsumerState<ScoredBoardView> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(roomController);
    return CustomPageBuilder(
      trailing: actions(state.roomCode),
      title: "Clasificacion",
      centerTitle: true,
      enableLeading: false,
      appbarColor: colors.gradientSecondary,
      body: UsersScoredListWidget(users: state.users),
      bottomBar: Padding(
        padding: EdgeInsets.all(16),
        child: CustomButton(
          text: "Finalizar y salir",
          height: 16,
          large: true,
          color: colors.orange,
          onTap: () => context.pop(),
        ),
      ),
    );
  }

  Widget actions(String roomCode) {
    return Row(
      children: [
        CustomCircularButton(
          icon: Icons.attach_email_outlined,
          onTap: () => _getReport(
            roomCode,
            attach: true,
          ),
        ),
        width.m,
        CustomCircularButton(
          icon: Icons.save_alt,
          onTap: () => _getReport(roomCode),
        ),
      ],
    );
  }

  Future<void> _getReport(String roomCode, {bool attach = false}) async {
    var session = await ref.read(roomController.notifier).getSessionByRoom(context, roomCode: roomCode);
    if (session.id != null) {
      if (mounted && attach) {
        var isSend = await ref.read(roomController.notifier).sendMailReport(context, sessionId: session.id ?? "");
        if (mounted && isSend) {
          return await context.showModal(title: "Informe enviado", content: "Hemos enviado el informe a tu correo.");
        }
      }
      view.launchURL(
        "${Config.apiUrl}reports/excel/${session.id ?? ""}",
        mode: LaunchMode.inAppWebView,
      );
    }
  }
}
