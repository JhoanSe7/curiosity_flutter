import 'package:curiosity_flutter/core/constants/config.dart';
import 'package:curiosity_flutter/core/constants/path_icons.dart';
import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/core/utils/extensions/message_extension.dart';
import 'package:curiosity_flutter/core/utils/util_page.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/generate_quiz_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/question_data_type.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/question_type.dart';
import 'package:curiosity_flutter/features/questionaries/presentation/questionary_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GenerateQuizView extends ConsumerStatefulWidget {
  const GenerateQuizView({super.key});

  @override
  ConsumerState<GenerateQuizView> createState() => _GenerateQuizViewState();
}

class _GenerateQuizViewState extends ConsumerState<GenerateQuizView> {
  ScrollController scrollController = ScrollController();
  final TextEditingController _promptController = TextEditingController();
  final GlobalKey _promptKey = GlobalKey();
  final GlobalKey _questionTypeKey = GlobalKey();

  String topicError = "";

  int questionCount = 10;
  int questionLimit = 15;
  int timeCount = 1;
  int timeLimit = 4;
  List<int> seconds = [15, 30, 45, 60, 90];
  bool spanish = true;
  List<int> summary = List.generate(4, (_) => 0);

  int get sumQuestions => summary.reduce((a, b) => a + b);

  List<QuestionDataType> get element {
    var element = Config.questionsType;
    var list = List<QuestionDataType>.from(element);
    list.removeWhere((e) => e.type == QuestionType.OPEN_ANSWER);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageBuilder(
      scrollController: scrollController,
      customTitle: titleWidget,
      appbarColor: colors.gradientPurple,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            infoQuestionary(),
            height.l,
            settingsQuestionary(),
            height.l,
            typeQuestionary(),
          ],
        ),
      ),
      bottomBar: generateButton(),
    );
  }

  Widget titleWidget = Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CustomText(
        "Generar con IA",
        color: colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      CustomText(
        "Configura tu cuestionario",
        fontSize: 14,
        color: colors.white,
      ),
    ],
  );

  Widget infoQuestionary() {
    return elementCard(
      child: Column(
        key: _promptKey,
        children: [
          headerCard(
            "Tema del cuestionario",
            "Describe de que tratara tu quiz",
            customLogo: GenericLogo(
              size: 25,
              padding: 8,
              logoColor: colors.white,
              isGradient: true,
              bgGradientColor: colors.gradientPurple,
              showComplement: false,
            ),
          ),
          height.l,
          CustomTextField(
            placeHolder: "Ej: Fundamentos de programación orientada a objetos, nivel facil...",
            controller: _promptController,
            maxLines: 5,
            textError: topicError,
            inputType: TextInputType.multiline,
            onChange: (_) => setState(() => topicError = ""),
          ),
        ],
      ),
    );
  }

  Widget elementCard({Widget? child}) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: colors.greyLight, offset: Offset(0, 3), blurRadius: 5),
        ],
      ),
      child: child,
    );
  }

  Widget headerCard(
    String title,
    String subtitle, {
    IconData? icon,
    List<Color>? color,
    Widget? customLogo,
    Widget? additionalWidget,
  }) {
    return Row(
      children: [
        (icon != null && color != null) ? iconCard(icon, color) : customLogo ?? SizedBox.shrink(),
        width.l,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                textAlign: TextAlign.start,
              ),
              CustomText(
                subtitle,
                color: colors.paragraph,
                fontSize: 12,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        width.l,
        additionalWidget ?? SizedBox.shrink(),
      ],
    );
  }

  Widget settingsQuestionary() {
    return elementCard(
      child: Column(
        children: [
          headerCard(
            "Configuracion",
            "Ajusta los parametros",
            icon: Icons.settings_outlined,
            color: colors.gradientBlue,
          ),
          height.l,
          selectorCount("Cantidad de preguntas", colors.green, questionCount, ActionCount.questions),
          height.l,
          selectorCount("Segundos por pregunta", colors.purple, seconds[timeCount], ActionCount.time),
          height.l,
          languageSelector(),
        ],
      ),
    );
  }

  Widget iconCard(IconData icon, List<Color> color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: color,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: CustomIcon(
        icon,
        size: 25,
        color: colors.white,
      ),
    );
  }

  Widget selectorCount(String title, Color color, int count, ActionCount action) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        height.m,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            countButton(Icons.remove, action, false),
            width.l,
            countText(count, color),
            width.l,
            countButton(Icons.add, action, true),
          ],
        ),
      ],
    );
  }

  Widget countButton(IconData icon, ActionCount action, bool opt) {
    return CustomGestureDetector(
      onTap: () => _actionCount(action, opt),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.inputBorder.withValues(alpha: .6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: CustomIcon(icon),
      ),
    );
  }

  _actionCount(ActionCount action, bool opt) async {
    switch (action) {
      case ActionCount.questions:
        if (sumQuestions > 0) {
          final res = await context.showModal(
            title: "¿Deseas continuar?",
            content: "Al cambiar este valor, se restablecerán los datos configurados en cada tipo de pregunta.",
            showClose: true,
            closeSize: 30,
          );
          if (res != true) return;
          summary = List.generate(4, (_) => 0);
        }
        _changeCountQuestion(opt);
        break;
      case ActionCount.time:
        _changeCountTime(opt);
        break;
    }
  }

  _changeCountQuestion(bool opt) {
    if (mounted) {
      setState(() {
        if (opt && questionCount < questionLimit) {
          questionCount += 1;
        } else if (!opt && questionCount > 1) {
          questionCount -= 1;
        }
      });
    }
  }

  _changeCountTime(bool opt) {
    if (mounted) {
      setState(() {
        if (opt && timeCount < timeLimit) {
          timeCount += 1;
        } else if (!opt && timeCount > 0) {
          timeCount -= 1;
        }
      });
    }
  }

  Widget countText(int count, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color),
        ),
        child: CustomText(
          count.toString(),
          color: color,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget languageSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          "Idioma del quiz",
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        height.m,
        Row(
          children: [
            languageButton("Español", colors.gradientSecondary, true),
            width.l,
            languageButton("Ingles", colors.gradientBlue, false)
          ],
        ),
      ],
    );
  }

  Widget languageButton(String text, List<Color> color, bool value) {
    var textColor = spanish == value ? colors.white : colors.titles;
    return Expanded(
      child: CustomButton(
        onTap: () => _selectLanguage(value),
        height: 14,
        isGradient: true,
        gradientColor: spanish == value ? color : colors.gradientInactive,
        child: CustomText(
          text,
          color: textColor,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    );
  }

  _selectLanguage(bool value) {
    setState(() {
      spanish = value;
    });
  }

  Widget typeQuestionary() {
    return elementCard(
      child: Column(
        key: _questionTypeKey,
        children: [
          headerCard(
            "Tipos de Pregunta",
            "Usa +/- para ajustar",
            icon: Icons.layers_outlined,
            color: colors.gradientGreen,
            additionalWidget: availableQuestions(),
          ),
          height.l,
          for (var e in element.asMap().entries) setQuestionTypeCard(e.key, e.value),
          height.m,
          if ((questionCount - sumQuestions) > 0) infoQuestions(),
        ],
      ),
    );
  }

  Widget availableQuestions() {
    return Container(
      width: 60,
      padding: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colors.yellow.withValues(alpha: .4),
      ),
      child: CustomText(
        "$sumQuestions/$questionCount",
        color: colors.orange,
        fontWeight: FontWeight.w600,
        fontSize: 14,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget setQuestionTypeCard(int index, QuestionDataType q) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: q.color).withOpacity(.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: q.color.last.withValues(alpha: .5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              iconQuestionType(q),
              width.l,
              CustomText(
                q.title,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
                fontSize: 14,
              ),
            ],
          ),
          height.m,
          optionsButton(index, q),
        ],
      ),
    );
  }

  Widget iconQuestionType(QuestionDataType q) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(colors: q.color, begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: CustomIcon(
        q.icon,
        color: colors.white,
        size: 20,
      ),
    );
  }

  Widget optionsButton(int index, QuestionDataType q) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        miniActionButton(Icons.remove, q, false, index),
        width.l,
        summaryText(index, q),
        width.l,
        miniActionButton(Icons.add, q, true, index),
      ],
    );
  }

  Widget summaryText(int index, QuestionDataType q) {
    return Container(
      width: 60,
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: colors.white,
        border: Border.all(color: q.color.last),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomText(
        summary[index].toString(),
        color: q.color.last,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget miniActionButton(IconData icon, QuestionDataType q, bool opt, int index) {
    return CustomGestureDetector(
      onTap: () => _action(opt, index),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: q.color.last),
        ),
        child: CustomIcon(
          icon,
          color: q.color.last,
        ),
      ),
    );
  }

  _action(bool opt, int i) {
    if (mounted) {
      setState(() {
        if (opt && summary[i] < (questionCount)) {
          if (questionCount == sumQuestions) return;
          summary[i] += 1;
        } else if (!opt && summary[i] > 0) {
          summary[i] -= 1;
        }
      });
    }
  }

  Widget infoQuestions() {
    var total = questionCount - sumQuestions;
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.yellow.withValues(alpha: .1),
        border: Border.all(color: colors.orange.withValues(alpha: .5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CustomIcon(
            Icons.info_outline,
            color: colors.orange,
            size: 20,
          ),
          width.l,
          CustomText(
            "Seleeciona $total ${total > 1 ? "tipos" : "tipo"} más",
            color: colors.orange,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            textAlign: TextAlign.start,
          )
        ],
      ),
    );
  }

  Widget generateButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CustomButton(
        onTap: _onTapGenerate,
        isGradient: true,
        gradientColor: colors.gradientPurple,
        height: 18,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomSvg(icons.star),
            CustomText(
              "Generar Cuestionario",
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: colors.white,
            ),
            width.l,
          ],
        ),
      ),
    );
  }

  _onTapGenerate() async {
    bool invalid = _inValidForm();
    if (invalid) return;
    _setError(clear: true);
    Map<String, int> questions = {};
    questions.addEntries(element.asMap().entries.map((e) => MapEntry(
          e.value.type.name,
          summary[e.key],
        )));
    var data = GenerateQuizModel(
      topic: _promptController.text,
      numberOfQuestions: questionCount,
      language: spanish ? "es" : "en",
      timePerQuestion: seconds[timeCount],
      questionDistribution: questions,
    );
    var res = await ref.read(questionaryController.notifier).generateQuiz(context, data: data);
    if ((res.title ?? "").isNotEmpty) {
      ref.read(questionaryController.notifier).setQuiz(res);
      if (mounted) context.pushReplacement(Routes.createQuiz);
    }
  }

  bool _inValidForm() {
    bool topicEmpty = _promptController.text.isEmpty;
    bool summaryEmpty = sumQuestions == 0;
    if (topicEmpty) {
      view.autoScroll(_promptKey.currentContext ?? context);
      _setError();
      return topicEmpty;
    }
    if (summaryEmpty) {
      view.autoScroll(_questionTypeKey.currentContext ?? context);
      context.showToast(
        text: "Debe seleccionar la cantidad de preguntas por tipo",
        type: MessageType.warning,
      );
      return summaryEmpty;
    }
    return false;
  }

  _setError({bool clear = false}) {
    if (mounted) {
      setState(() {
        topicError = clear ? "" : "Escribe un tema para el cuestionario";
      });
    }
  }
}

enum ActionCount {
  questions,
  time,
}
