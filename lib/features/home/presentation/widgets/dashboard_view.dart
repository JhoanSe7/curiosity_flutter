import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/core/utils/utils.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:curiosity_flutter/features/questionaries/presentation/questionary_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  List<Color> allColors = [
    colors.blue,
    colors.green,
    colors.purple,
    colors.orange,
  ];

  List<Color> colorCard = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadData);
  }

  _loadData() async {
    await ref.read(homeController.notifier).loadQuizzes(context);
    colorCard = List.generate(
      ref.read(homeController).quizzes.length,
      (index) => allColors[index % allColors.length],
    );
  }

  final TextEditingController _codeInput = TextEditingController();

  @override
  void dispose() {
    _codeInput.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final state = ref.read(homeController);
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          quickAccessWidget(),
          SizedBox(height: 32),
          if (state.user?.createdQuizzes?.isEmpty ?? true) ...[
            beginWidget(),
            SizedBox(height: 32),
          ],
          questionnairesWidget(state.quizzes),
        ],
      ),
    );
  }

  Widget quickAccessWidget() {
    return Column(
      children: [
        subtitleWidget("Acciones Rápidas", Icons.electric_bolt_outlined, colors.yellow),
        SizedBox(height: 16),
        Row(
          children: [
            quickAccessButton(
              "Crear Quiz",
              "Diseña tu\ncuestionario",
              Icons.add,
              colors.gradientSecondary,
              () => context.push(Routes.questionary),
            ),
            SizedBox(width: 16),
            quickAccessButton(
              "Unirse",
              "Código de quiz",
              Icons.numbers,
              colors.gradientPrimary,
              () => _showCodeModal(),
            ),
          ],
        )
      ],
    );
  }

  Widget subtitleWidget(String text, IconData icon, Color color) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
        ),
        SizedBox(width: 8),
        CustomText(
          text,
          fontType: FontType.title,
        ),
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
          height: context.height * .18,
          padding: EdgeInsets.all(16),
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
                child: Icon(
                  icon,
                  color: colors.white,
                ),
              ),
              SizedBox(height: 8),
              CustomText(
                title,
                color: colors.white,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 4),
              CustomText(
                desc,
                color: colors.white,
                fontType: FontType.h6,
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
        subtitleWidget("¿Cómo empezar?", Icons.star_border, colors.yellow),
        SizedBox(height: 16),
        CustomCard(
          subtitle: "Paso 1",
          title: "Crea tu primer quiz",
          desc: "Diseña preguntas divertidas sobre cualquier tema que te apasione",
          icon: Icons.add,
          bgColor: colors.gradientPurple,
          color: colors.purple,
          enableShadow: true,
        ),
        SizedBox(height: 16),
        CustomCard(
          subtitle: "Paso 2",
          title: "Comparte el código",
          desc: "Invita a tus amigos a jugar usando el código unico de tu quiz",
          icon: Icons.numbers,
          bgColor: colors.gradientPrimary,
          color: colors.aquamarine,
          enableShadow: true,
        ),
        SizedBox(height: 16),
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
    return Column(
      children: [
        subtitleWidget("Mis Cuestionarios", Icons.menu_book, colors.purple),
        SizedBox(height: 16),
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
            : quizzesListWidget(quizzes),
      ],
    );
  }

  Widget creationQuizWidget() {
    return Column(
      children: [
        GenericLogo(),
        SizedBox(height: 16),
        CustomText(
          "¡Tu primer custionario te espera!",
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        SizedBox(height: 16),
        CustomText(
          "Crea cuestionarios increibles y comparte tu conocimiento con el mundo",
          fontType: FontType.h5,
          color: colors.paragraph,
        ),
        SizedBox(height: 16),
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
              Icon(
                Icons.add,
                color: colors.white,
              ),
              SizedBox(width: 16),
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

  Widget quizzesListWidget(List<QuizModel> quizzes) {
    return Column(children: quizzes.asMap().entries.map((e) => quizCard(e.key, e.value)).toList());
  }

  Widget quizCard(int i, QuizModel q) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: colorCard[i], offset: Offset(0, -5)),
          BoxShadow(color: colors.greyLight.withValues(alpha: .5), offset: Offset(0, 5), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [titleQuiz(q), moreOptions(q)],
          ),
          CustomText(
            q.description ?? "",
            textAlign: TextAlign.start,
            fontWeight: FontWeight.w500,
            color: colors.paragraph,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [questionsSizeText(q), startQuizButton(i)],
          )
        ],
      ),
    );
  }

  Widget titleQuiz(QuizModel q) {
    return Row(
      children: [
        CustomText(
          q.title ?? "",
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        width.m,
        statusQuiz()
      ],
    );
  }

  Widget statusQuiz() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      decoration: BoxDecoration(
        color: colors.green.withValues(alpha: .2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: CustomText(
        "Activo",
        color: colors.green,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
    );
  }

  Widget moreOptions(QuizModel q) {
    return PopupMenuButton(
      onSelected: (value) => _onSelected(q, value),
      color: colors.white,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: Option.edit,
          child: Row(
            children: [
              Icon(
                Icons.edit,
                size: 24,
                color: colors.iconPlaceholder,
              ),
              width.m,
              CustomText(
                "Editar",
                color: colors.paragraph,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: Option.edit,
          child: Row(
            children: [
              Icon(
                Icons.delete_forever_outlined,
                size: 24,
                color: colors.red,
              ),
              width.m,
              CustomText(
                "Eliminar",
                color: colors.red,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ],
    );
  }

  _onSelected(QuizModel q, Option value) {
    switch (value) {
      case Option.edit:
        ref.read(questionaryController.notifier).setQuiz(q);
        context.push(Routes.createQuiz);
        break;
      case Option.delete:
        break;
    }
  }

  Widget questionsSizeText(QuizModel q) {
    var length = q.questions?.length ?? 0;
    return Row(
      children: [
        Icon(
          Icons.description_outlined,
          color: colors.iconPlaceholder,
          size: 20,
        ),
        CustomText(
          "$length ${length > 1 ? "preguntas" : "pregunta"}",
          fontSize: 14,
          color: colors.paragraph,
        ),
      ],
    );
  }

  Widget startQuizButton(int i) {
    return CustomGestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: colorCard[i],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.play_arrow,
              color: colors.white,
            ),
            CustomText(
              "Iniciar",
              color: colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ],
        ),
      ),
    );
  }

  _showCodeModal() {
    final state = ref.watch(homeController);
    return context.showModal(
      widthContainer: .8,
      icon: Icons.numbers_rounded,
      iconColor: colors.primary,
      title: "¡Únete al Quiz!",
      content: "Ingresa el código único de tu quiz para comenzar a jugar y aprender con tus amigos",
      actions: Flexible(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: Colors.transparent,
              child: CustomTextField(
                placeHolder: 'EJ: ABC123',
                controller: _codeInput,
              ),
            ),
            height.l,
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      _codeInput.clear();
                      context.pop();
                    },
                    height: 18,
                    text: "Cancelar",
                    textColor: colors.titles,
                    color: colors.inputBorder,
                  ),
                ),
                width.l,
                Expanded(
                  child: CustomButton(
                    onTap: () async {
                      final data = {
                        "roomCode": _codeInput.text.trim(),
                        "userId": state.user?.id,
                        "firstName": state.user?.firstName,
                        "secondName": state.user?.secondName,
                        "lastName": state.user?.lastName,
                        "secondLastName": state.user?.secondLastName,
                        "email": state.user?.email,
                        "phoneNumber": state.user?.phoneNumber,
                        "role": state.user?.role,
                      };
                      await context.push(Routes.lobbyGuest, extra: data);
                      _codeInput.clear();
                      context.pop();
                    },
                    height: 18,
                    text: "Unirse",
                    color: colors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum Option {
  edit,
  delete,
}
