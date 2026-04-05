import 'package:curiosity_flutter/core/constants/config.dart';
import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/core/utils/util_page.dart';
import 'package:curiosity_flutter/features/home/data/models/session_model.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:curiosity_flutter/features/room/presentation/widgets/users_scored_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class SessionResultUsersView extends ConsumerStatefulWidget {
  const SessionResultUsersView({super.key});

  @override
  ConsumerState<SessionResultUsersView> createState() => _SessionResultUsersViewState();
}

class _SessionResultUsersViewState extends ConsumerState<SessionResultUsersView> {
  @override
  Widget build(BuildContext context) {
    final state = ref.read(homeController);
    var session = state.sessionSelected ?? SessionModel();
    return CustomPageBuilder(
      trailing: actions(session.id ?? ""),
      centerTitle: true,
      title: session.quizTitle ?? "Resultados",
      appbarColor: colors.gradientViolet,
      body: UsersScoredListWidget(users: session.players ?? [], onTap: (e) => _onTapDetail(session.roomCode, e.id)),
    );
  }

  Widget actions(String sessionId) {
    return Row(
      children: [
        CustomCircularButton(
          icon: Icons.save_alt,
          onTap: () => _getReport(sessionId),
        )
      ],
    );
  }

  Future<void> _onTapDetail(String? roomCode, String? userId) async {
    if ((roomCode ?? "").isNotEmpty && (userId ?? "").isNotEmpty) {
      final controller = ref.read(homeController.notifier);
      var res = await controller.getResultSessionUser(context, roomCode: roomCode ?? "", userId: userId ?? "");
      if ((res.id ?? "").isNotEmpty) {
        controller.setResultDetail(res);
        if (mounted) context.push(Routes.resultDetail);
      }
    }
  }

  _getReport(String sessionId) {
    view.launchURL(
      "${Config.apiUrl}reports/excel/$sessionId",
      mode: LaunchMode.inAppWebView,
    );
  }
}
