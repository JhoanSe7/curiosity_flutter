import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/core/utils/utils.dart';
import 'package:curiosity_flutter/features/qr_scanner/data/models/qr_scanner_model.dart';
import 'package:curiosity_flutter/features/qr_scanner/presentation/qr_scanner.dart';
import 'package:curiosity_flutter/features/room/presentation/room_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class JoinRoomView extends ConsumerStatefulWidget {
  const JoinRoomView({super.key});

  @override
  ConsumerState<JoinRoomView> createState() => _JoinRoomViewState();
}

class _JoinRoomViewState extends ConsumerState<JoinRoomView> {
  final TextEditingController _codeInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomPageBuilder(
      title: "¡Únete al Quiz!",
      centerTitle: true,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CustomText(
              "Ingresa el código único de tu quiz para comenzar a jugar y aprender con tus amigos",
              fontSize: 14,
            ),
            height.l,
            CustomTextField(
              placeHolder: 'EJ: ABC123',
              controller: _codeInput,
              formatters: InputFilters.alphaNumeric(
                inputLength: 6,
                allowSpace: false,
                uppercase: true,
              ),
              onSubmit: (_) => _onJoinQuiz(),
            ),
            height.l,
            CustomButton(
              onTap: _onJoinQuiz,
              height: 16,
              text: "Unirse",
              large: true,
              color: colors.primary,
            ),
            height.l,
            CustomText(
              "o escanear código",
              fontSize: 14,
            ),
            height.l,
            CustomButton(
              onTap: _scanQr,
              height: 16,
              color: colors.whiteSmoke,
              border: Border.all(color: colors.iconPlaceholder),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIcon(Icons.qr_code_2),
                  width.m,
                  CustomText(
                    "Escanear código QR",
                    fontSize: 14,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onJoinQuiz() async {
    bool invalid = _validateCode();
    if (invalid) return;
    final controller = ref.read(roomController.notifier);
    var code = _codeInput.text.trim();
    var res = await controller.validateRoom(context, roomCode: code);
    if (res && mounted) {
      controller.setRoomCode(code);
      context.pushReplacement(Routes.lobby);
    }
    _codeInput.clear();
  }

  bool _validateCode() {
    bool empty = _codeInput.text.trim().isEmpty;
    if (empty) context.showModal(title: "Atención", content: "El código no es válido");
    return empty;
  }

  _scanQr() async {
    var code = await QrScanner.scan(context);
    if (code.code == QrScanStatus.success) {
      _codeInput.text = code.rawValue;
      _onJoinQuiz();
    }
  }
}
