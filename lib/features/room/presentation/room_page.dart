import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/design/templates/qr_preview.dart';
import 'package:curiosity_flutter/core/utils/extensions/message_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'room_controller.dart';
import 'widgets/participants_widget.dart';

class RoomPage extends ConsumerStatefulWidget {
  const RoomPage({super.key});

  @override
  ConsumerState<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends ConsumerState<RoomPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(roomController);
    return CustomPageBuilder(
      title: "",
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
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                CustomText(
                  "Escanea para unirte",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                CustomText(
                  "Usa la camara desde la app",
                  fontSize: 14,
                  color: colors.paragraph,
                ),
                QrPreview(
                  code: roomCode,
                  size: 150,
                  color: colors.blue,
                ),
              ],
            ),
          ),
          height.l,
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                CustomText(
                  "Codigo de sala",
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                CustomText(
                  "Comparte este codigo para unirse",
                  fontSize: 14,
                  color: colors.paragraph,
                ),
                height.l,
                Container(
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
                ),
                height.l,
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 32),
                  child: CustomButton(
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
          ),
        ],
      ),
    );
  }
}
