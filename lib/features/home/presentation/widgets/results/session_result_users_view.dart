import 'dart:io';

import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/core/utils/extensions/message_extension.dart';
import 'package:curiosity_flutter/features/home/data/models/session_model.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:curiosity_flutter/features/room/presentation/room_controller.dart';
import 'package:curiosity_flutter/features/room/presentation/widgets/users_scored_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

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
      body: UsersScoredListWidget(
        users: session.players ?? [],
        onTap: (e) => _onTapDetail(session.roomCode, e.id),
      ),
    );
  }

  Widget actions(String sessionId) {
    return Row(
      children: [
        CustomCircularButton(
          icon: Icons.attach_email_outlined,
          onTap: () => _getReport(sessionId, attach: true),
        ),
        width.m,
        CustomCircularButton(
          icon: Icons.save_alt,
          onTap: () => _getReport(sessionId),
        ),
      ],
    );
  }

  Future<void> _onTapDetail(String? roomCode, String? userId) async {
    if ((roomCode ?? "").isNotEmpty && (userId ?? "").isNotEmpty) {
      final controller = ref.read(homeController.notifier);
      var res = await controller.getResultSessionUser(
        context,
        roomCode: roomCode ?? "",
        userId: userId ?? "",
      );
      if ((res.id ?? "").isNotEmpty) {
        controller.setResultDetail(res);
        if (mounted) context.push(Routes.resultDetail);
      }
    }
  }

  Future<dynamic> _getReport(String sessionId, {bool attach = false}) async {
    final controller = ref.read(roomController.notifier);
    if (attach) {
      var isSend = await controller.sendMailReport(context, sessionId: sessionId);
      if (mounted && isSend) {
        return await context.showModal(
          title: "Informe enviado",
          content: "Hemos enviado el informe a tu correo.",
        );
      }
    }
    if (!mounted) return;
    var bytes = await controller.downloadReport(context, sessionId: sessionId);
    if (bytes == null) return;
    await _saveReport(bytes);
  }

  Future<void> _saveReport(dynamic bytes) async {
    try {
      final success = await _saveToDownloads(bytes);
      if (!mounted) return;
      context.pop();
      context.showToast(
        text: success ? "Reporte guardado en Descargas" : "No se pudo guardar el reporte",
        type: success ? MessageType.success : MessageType.warning,
      );
    } catch (e) {
      if (!mounted) return;
      context.showToast(
        text: "Error al guardar el reporte",
        type: MessageType.error,
      );
    }
  }

  Future<bool> _saveToDownloads(dynamic bytes) async {
    if (Platform.isAndroid) {
      final dir = Directory('/storage/emulated/0/Download');
      if (!await dir.exists()) await dir.create(recursive: true);

      final file = File('${dir.path}/reporte_${DateTime.now().millisecondsSinceEpoch}.xlsx');
      await file.writeAsBytes(bytes);
      return true;
    } else if (Platform.isIOS) {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/reporte_${DateTime.now().millisecondsSinceEpoch}.xlsx');
      await file.writeAsBytes(bytes);
      return true;
    }
    return false;
  }
}
