import 'dart:ui';

import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/design/templates/qr_preview.dart';
import 'package:curiosity_flutter/core/utils/extensions/message_extension.dart';
import 'package:curiosity_flutter/features/questionaries/presentation/questionary_controller.dart';
import 'package:curiosity_flutter/features/room/presentation/widgets/participants_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:share_plus/share_plus.dart';

import 'room_controller.dart';

class RoomPage extends ConsumerStatefulWidget {
  const RoomPage({super.key});

  @override
  ConsumerState<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends ConsumerState<RoomPage> {
  late QrImage qrImage;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(roomController);
    final quiz = ref.read(questionaryController).quiz;
    return CustomPageBuilder(
      title: quiz?.title ?? "",
      appbarColor: colors.gradientBlue,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CustomButton(
              height: 16,
              large: true,
              text: "Invitar participantes",
              isGradient: true,
              gradientColor: colors.gradientBlue,
              onTap: () => _inviteBottomSheet(state.roomCode),
            ),
            ParticipantsWidget(0),
          ],
        ),
      ),
    );
  }

  _inviteBottomSheet(String roomCode) async {
    await context.showBottomSheetModal(
      title: "Invitar participantes",
      child: Column(
        children: [
          CustomButton(
            onTap: () => _shareRoom(roomCode),
            height: 16,
            large: true,
            isGradient: true,
            gradientColor: colors.gradientBlue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIcon(
                  Icons.share,
                  size: 18,
                  color: colors.white,
                ),
                width.m,
                CustomText(
                  "Compartir sala",
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: colors.white,
                ),
              ],
            ),
          ),
          height.l,
          qrCard(roomCode),
          height.l,
          codeCard(roomCode),
        ],
      ),
    );
  }

  Widget qrCard(String roomCode) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          titleCard("Escanea para unirte", "Usa la camara desde la app"),
          QrPreview(
            builder: (widget, data) {
              qrImage = data;
              return widget;
            },
            code: roomCode,
            size: 150,
            color: colors.blue,
          ),
        ],
      ),
    );
  }

  Widget titleCard(String tex1, String tex2) {
    return Column(
      children: [
        CustomText(
          tex1,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        CustomText(
          tex2,
          fontSize: 14,
          color: colors.paragraph,
        ),
      ],
    );
  }

  Widget codeCard(String roomCode) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          titleCard("Codigo de sala", "Comparte este codigo para unirse"),
          height.l,
          textCode(roomCode),
          height.l,
          Container(
            margin: EdgeInsets.symmetric(horizontal: 32),
            child: CustomButton(
              onTap: () => _copyRoom(roomCode),
              height: 18,
              isGradient: true,
              gradientColor: colors.gradientGrey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIcon(
                    Icons.copy,
                    size: 18,
                    color: colors.white,
                  ),
                  width.m,
                  CustomText(
                    "Copiar codigo",
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textCode(String roomCode) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.inputBorder),
        boxShadow: [
          BoxShadow(color: colors.greyLight.withValues(alpha: .3), offset: Offset(0, 2), blurRadius: 6),
        ],
      ),
      child: CustomText(
        roomCode,
        color: colors.blue,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  _shareRoom(String roomCode) async {
    var file = await qrImageFile;
    var params = ShareParams(
      text: '¡Únete a mi quiz en Curiosity!\nUsa el código: $roomCode',
      subject: 'Participa en mi quiz – Código **$roomCode**',
      files: [file],
    );
    var result = await SharePlus.instance.share(params);
    if (mounted) {
      context.pop();
      bool success = result.status == ShareResultStatus.success;
      context.showToast(
          text: success ? "Sala compartida con exito" : "No se pudo compartir la sala",
          type: success ? MessageType.success : MessageType.warning);
    }
  }

  Future<XFile> get qrImageFile async {
    var data = await qrImage.toImageAsBytes(
      size: 512,
      format: ImageByteFormat.png,
      decoration: PrettyQrDecoration(
        background: colors.white,
        shape: PrettyQrShape.custom(
          PrettyQrSquaresSymbol(color: colors.blue),
          finderPattern: PrettyQrSmoothSymbol(color: colors.blue),
        ),
      ),
    );
    final Uint8List bytes = data!.buffer.asUint8List();
    return XFile.fromData(
      bytes,
      name: 'qr_room.png',
      mimeType: 'image/png',
    );
  }

  _copyRoom(String roomCode) async {
    await Clipboard.setData(ClipboardData(text: roomCode));
    if (mounted) {
      context.pop();
      context.showToast(text: "Código copiado exitosamente");
    }
  }
}
