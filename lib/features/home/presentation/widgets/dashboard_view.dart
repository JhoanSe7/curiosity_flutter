import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/core/utils/utils.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:curiosity_flutter/features/qr_scanner/data/models/qr_scanner_model.dart';
import 'package:curiosity_flutter/features/qr_scanner/presentation/qr_scanner.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:curiosity_flutter/features/questionaries/presentation/widgets/quizzes_card_widget.dart';
import 'package:curiosity_flutter/features/room/presentation/room/room_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'show_more_widget.dart';
import 'subtitle_widget.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  final TextEditingController _codeInput = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(homeController.notifier).setLoading(true));
    Future.microtask(_loadData);
  }

  _loadData() async {
    await ref.read(homeController.notifier).loadQuizzes(context);
    ref.read(homeController.notifier).setLoading(false);
  }

  @override
  void dispose() {
    _codeInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeController);
    return Skeletonizer(
      enabled: state.isLoading,
      justifyMultiLineText: true,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            quickAccessWidget(),
            height.xl,
            if (state.user?.createdQuizzes?.isEmpty ?? true) ...[
              beginWidget(),
              height.xl,
            ],
            questionnairesWidget(state.quizzes),
          ],
        ),
      ),
    );
  }

  Widget quickAccessWidget() {
    return Column(
      children: [
        SubtitleWidget("Acciones Rápidas", Icons.electric_bolt_outlined, colors.yellow),
        height.l,
        Row(
          children: [
            quickAccessButton(
              "Crear Quiz",
              "Diseña tu\ncuestionario",
              Icons.add,
              colors.gradientSecondary,
              () => context.push(Routes.questionary),
            ),
            width.l,
            quickAccessButton(
              "Unirse",
              "Código de quiz",
              Icons.numbers,
              colors.gradientPrimary,
              () => _joinRoomBottomSheet(),
            ),
          ],
        )
      ],
    );
  }

  Widget quickAccessButton(
    String title,
    String desc,
    IconData icon,
    List<Color> bgColor,
    void Function() onTap,
  ) {
    return Expanded(
      child: CustomGestureDetector(
        onTap: onTap,
        child: Container(
          height: context.scale(context.height * .18),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: colors.greyLight, offset: Offset(0, 3), blurRadius: 10),
            ],
            gradient: LinearGradient(
              colors: bgColor,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: colors.white.withValues(alpha: .3),
                ),
                child: CustomIcon(
                  icon,
                  color: colors.white,
                  size: 18,
                ),
              ),
              height.m,
              CustomText(
                title,
                color: colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
              height.s,
              CustomText(
                desc,
                color: colors.white,
                fontSize: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget beginWidget() {
    return Column(
      children: [
        SubtitleWidget("¿Cómo empezar?", Icons.star_border, colors.yellow),
        height.l,
        CustomCard(
          subtitle: "Paso 1",
          title: "Crea tu primer quiz",
          desc: "Diseña preguntas divertidas sobre cualquier tema que te apasione",
          icon: Icons.add,
          bgColor: colors.gradientPurple,
          color: colors.purple,
          enableShadow: true,
        ),
        height.l,
        CustomCard(
          subtitle: "Paso 2",
          title: "Comparte el código",
          desc: "Invita a tus amigos a jugar usando el código unico de tu quiz",
          icon: Icons.numbers,
          bgColor: colors.gradientPrimary,
          color: colors.aquamarine,
          enableShadow: true,
        ),
        height.l,
        CustomCard(
          subtitle: "Paso 3",
          title: "Juega y aprende",
          desc: "Compite en tiempo real y descubre quién sabe más",
          icon: Icons.electric_bolt_outlined,
          bgColor: colors.gradientYellow,
          color: colors.orange,
          enableShadow: true,
        ),
      ],
    );
  }

  Widget questionnairesWidget(List<QuizModel> quizzes) {
    var shortList = quizzes.length > 2 ? quizzes.sublist(0, 2) : quizzes;
    var less = quizzes.length - 2;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SubtitleWidget("Mis Cuestionarios", Icons.menu_book, colors.purple),
            if (quizzes.isNotEmpty) ShowMoreWidget("Ver todos"),
          ],
        ),
        height.l,
        quizzes.isEmpty
            ? Container(
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.inputBorder),
                ),
                child: creationQuizWidget(),
              )
            : Column(
                children: shortList.asMap().entries.map((e) => QuizzesCardWidget(e.key, e.value)).toList(),
              ),
        if (less > 0)
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: colors.greyLight.withValues(alpha: .5), offset: Offset(0, 3), blurRadius: 1),
              ],
            ),
            child: ShowMoreWidget("Ver los${less > 1 ? " $less " : " "}cuestionarios restantes"),
          )
      ],
    );
  }

  Widget creationQuizWidget() {
    return Column(
      children: [
        GenericLogo(),
        height.l,
        CustomText(
          "¡Tu primer custionario te espera!",
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        height.l,
        CustomText(
          "Crea cuestionarios increibles y comparte tu conocimiento con el mundo",
          color: colors.paragraph,
          fontSize: 16,
        ),
        height.l,
        CustomButton(
          onTap: () => context.push(Routes.questionary),
          width: 24,
          height: 12,
          isGradient: true,
          gradientColor: colors.gradientPurple,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIcon(
                Icons.add,
                color: colors.white,
              ),
              width.l,
              CustomText(
                "Crear mi primer quiz",
                color: colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              )
            ],
          ),
        )
      ],
    );
  }

  _joinRoomBottomSheet() async {
    await context.showBottomSheetModal(
      title: "¡Únete al Quiz!",
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
    );
  }

  _onJoinQuiz() async {
    bool invalid = _validateCode();
    if (invalid) return;
    ref.read(roomController.notifier).setRoomCode(_codeInput.text.trim());
    context.pop();
    context.push(Routes.lobby);
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
