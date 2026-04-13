import 'dart:io';

import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/utils/extensions/message_extension.dart';
import 'package:curiosity_flutter/features/room/presentation/room_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

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
          onTap: () => _getReport(roomCode, attach: true),
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
    final controller = ref.read(roomController.notifier);
    var session = await controller.getSessionByRoom(context, roomCode: roomCode);
    var sessionId = session.id ?? "";
    if (session.id != null) {
      if (mounted && attach) {
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
