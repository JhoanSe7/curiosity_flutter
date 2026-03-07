import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/utils/utils.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/option_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/question_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/question_type.dart';
import 'package:curiosity_flutter/features/questionaries/presentation/questionary_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateQuestionView extends ConsumerStatefulWidget {
  const CreateQuestionView({super.key});

  @override
  ConsumerState<CreateQuestionView> createState() => _CreateQuestionViewState();
}

class _CreateQuestionViewState extends ConsumerState<CreateQuestionView> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  final TextEditingController _explanationController = TextEditingController();
  final GlobalKey _questionKey = GlobalKey();
  final GlobalKey _typeOptionKey = GlobalKey();
  final GlobalKey _timeOptionKey = GlobalKey();

  List<int> seconds = [15, 30, 45, 60, 90];
  List<OptionModel> options = [];
  List<TextEditingController> optionControllers = [];

  bool? binarySelected;
  int timeSelected = 0;
  int error = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadData);
  }

  _loadData() {
    _setQuestion();
    if (options.isEmpty) options = List.generate(4, (i) => OptionModel(id: i, isCorrect: false));
    optionControllers = List.generate(4, (i) => TextEditingController(text: options[i].text));
    if (mounted) setState(() => isLoading = false);
  }

  _setQuestion() {
    var state = ref.read(questionaryController);
    if (state.question != null && state.question?.question != null) {
      _questionController.text = state.question?.question ?? "";
      _answerController.text = state.question?.correctAnswerText ?? "";
      _explanationController.text = state.question?.explanation ?? "";
      if (mounted) {
        setState(() {
          timeSelected = state.question?.timeLimit ?? 0;
          binarySelected = state.question?.correctAnswer;
          options = state.question?.options ?? options;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(questionaryController);
    var question = state.questionType;
    return CustomPageBuilder(
      title: question?.title ?? "Pregunta",
      appbarColor: question?.color,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              key: _questionKey,
              child: CustomTextField(
                label: "Pregunta",
                controller: _questionController,
                placeHolder: "Escribe tu pregunta aquí...",
                maxLines: 5,
                inputType: TextInputType.multiline,
                textError: error == 1 ? "Debes escribir una pregunta" : "",
                onChange: (_) => _setError(0),
              ),
            ),
            height.xl,
            if (!isLoading)
              Container(
                key: _typeOptionKey,
                child: questionTypeOption(question?.type ?? QuestionType.OPEN_ANSWER),
              ),
            height.xl,
            if (question?.type != QuestionType.OPEN_ANSWER) ...[
              explanationField(),
              height.xl,
            ],
            timeOptions(),
          ],
        ),
      ),
      bottomBar: actions(question?.color),
    );
  }

  Widget questionTypeOption(QuestionType q) => switch (q) {
        QuestionType.SINGLE_SELECTION => simpleQuestion(),
        QuestionType.MULTIPLE_SELECTION => multipleQuestion(),
        QuestionType.FILL_IN_THE_BLANK => completeQuestion(),
        QuestionType.TRUE_FALSE => binaryQuestion(),
        QuestionType.OPEN_ANSWER => openQuestion(),
      };

  Widget actions(List<Color>? color) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              onTap: () => context.pop(),
              height: 18,
              text: "Cancelar",
              textColor: colors.titles,
              color: colors.inputBorder,
            ),
          ),
          width.l,
          Expanded(
            child: CustomButton(
              onTap: () => _saveQuestion(),
              height: 18,
              text: "Guardar Pregunta",
              gradientColor: color,
              isGradient: true,
            ),
          ),
        ],
      ),
    );
  }

  _saveQuestion() {
    var empty = _validateButton();
    if (empty) return;
    _setError(0);
    var data = QuestionModel(
      question: _questionController.text,
      type: ref.read(questionaryController).questionType?.type.name,
      timeLimit: timeSelected,
      correctAnswer: binarySelected,
      correctAnswerText: _answerController.text,
      options: options.asMap().entries.map((e) => e.value.copyWith(optionControllers[e.key].text)).toList(),
      explanation: _explanationController.text,
    );
    ref.read(questionaryController.notifier).addQuestion(data);
    context.removeByQuantity(2);
  }

  _validateButton() {
    bool textEmpty = _questionController.text.isEmpty;
    bool questionTypeEmpty = _validQuestion();
    bool timeEmpty = timeSelected == 0;
    if (textEmpty) {
      view.autoScroll(_questionKey.currentContext ?? context);
      _setError(1);
    } else if (questionTypeEmpty) {
      view.autoScroll(_timeOptionKey.currentContext ?? context);
      _setError(2);
    } else if (timeEmpty) {
      view.autoScroll(_timeOptionKey.currentContext ?? context);
      _setError(3);
    }
    return textEmpty || timeEmpty || questionTypeEmpty;
  }

  _setError(int code) {
    if (mounted) {
      setState(() {
        error = code;
      });
    }
  }

  bool _validQuestion() {
    var questionType = ref.read(questionaryController).questionType?.type;
    switch (questionType) {
      case null:
        return false;
      case QuestionType.SINGLE_SELECTION:
      case QuestionType.MULTIPLE_SELECTION:
        return options.every((e) => !e.isCorrect || optionControllers[e.id].text.isEmpty);
      case QuestionType.FILL_IN_THE_BLANK:
        return _answerController.text.isEmpty;
      case QuestionType.TRUE_FALSE:
        return binarySelected == null;
      case QuestionType.OPEN_ANSWER:
        return false;
    }
  }

  Widget explanationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          "Explicacion de la respuesta (opcional)",
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        height.l,
        CustomTextField(
          placeHolder: "Explica porque esa es la respuesta correcta",
          controller: _explanationController,
          maxLines: 3,
          inputType: TextInputType.multiline,
        ),
      ],
    );
  }

  Widget timeOptions() {
    return Column(
      key: _timeOptionKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          "Tiempo limite (segundos)",
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        height.l,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: seconds.map((e) => timeBox(e)).toList(),
        ),
        if (error == 3) errorText("Debes seleccionar un tiempo de respuesta"),
      ],
    );
  }

  Widget timeBox(int e) {
    return CustomGestureDetector(
      onTap: () => _timeTap(e),
      child: Container(
        decoration: BoxDecoration(
          color: timeSelected == e ? colors.primary : colors.inputBorder,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: CustomText(
          "${e}s",
          color: timeSelected == e ? colors.white : colors.paragraph,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  _timeTap(int e) {
    if (mounted) {
      setState(() {
        timeSelected = e;
      });
    }
  }

  Widget simpleQuestion() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            "Opciones de respuesta",
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          height.l,
          ...options.map((e) => questionOption(e, e.isCorrect, () => _checkTap(e))),
          if (error == 2) errorText("Verifica todas las opciones de respuesta y selecciona una correcta"),
        ],
      );

  Widget questionOption(OptionModel e, bool enable, void Function() onTap) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Flexible(
            child: CustomTextField(
              placeHolder: "Opción ${e.id + 1}",
              controller: optionControllers[e.id],
            ),
          ),
          width.m,
          checkQuestion(enable, onTap),
        ],
      ),
    );
  }

  Widget checkQuestion(bool enable, void Function() onTap) {
    return CustomGestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: enable ? colors.primary : colors.inputBorder,
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomIcon(
          Icons.check,
          color: colors.white,
        ),
      ),
    );
  }

  _checkTap(OptionModel o) {
    if (mounted) {
      setState(() {
        for (int i = 0; i < options.length; i++) {
          var option = options[i];
          option.isCorrect = o.id == i ? !option.isCorrect : false;
        }
      });
    }
  }

  Widget multipleQuestion() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            "Opciones de respuesta",
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          height.l,
          ...options.map((e) => questionOption(e, e.isCorrect, () => _checkAdd(e))),
          if (error == 2) errorText("Verifica todas las opciones de respuesta y selecciona al menos una correcta"),
        ],
      );

  _checkAdd(OptionModel e) {
    var option = options[e.id];
    if (mounted) {
      setState(() {
        option.isCorrect = !option.isCorrect;
      });
    }
  }

  Widget completeQuestion() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            "Respuesta correcta",
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          height.l,
          CustomTextField(
            text: "Escribe la respuesta correcta",
            controller: _answerController,
            textError: error == 2 ? "Debes escribir la respuesta correcta" : "",
          )
        ],
      );

  Widget binaryQuestion() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            "Respuesta correcta",
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          height.l,
          Row(
            children: [
              binaryButton("Verdadero", Icons.check, colors.primary, true),
              width.m,
              binaryButton("Falso", Icons.close, colors.red, false),
            ],
          ),
          if (error == 2) errorText("Debes seleccionar la respuesta correcta"),
        ],
      );

  Widget binaryButton(String text, IconData icon, Color color, bool value) {
    var textColor = binarySelected == value ? colors.white : colors.paragraph;
    return Expanded(
      child: CustomButton(
        onTap: () => _binaryTap(value),
        height: 18,
        color: binarySelected == value ? color : colors.inputBorder,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIcon(icon, color: textColor),
            width.m,
            CustomText(
              text,
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ],
        ),
      ),
    );
  }

  _binaryTap(bool value) {
    if (mounted) {
      setState(() {
        binarySelected = value;
      });
    }
  }

  Widget openQuestion() => Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: colors.aquamarine.withValues(alpha: .1),
              border: Border.all(color: colors.aquamarine.withValues(alpha: .5)),
            ),
            child: RichText(
              text: TextSpan(
                style: styles.poppins(),
                children: [
                  TextSpan(
                    text: "Nota: ",
                    style: styles.poppins(fontWeight: FontWeight.w600, fontSize: context.scale(12)),
                  ),
                  TextSpan(
                    text: "Las respuestas abiertas serán revisadas manualmente por ti después del quiz.",
                    style: styles.poppins(fontSize: context.scale(12)),
                  )
                ],
              ),
            ),
          ),
        ],
      );

  Widget errorText(String text) {
    return Column(
      children: [
        height.m,
        Align(
          alignment: Alignment.centerLeft,
          child: CustomText(
            text,
            color: colors.red,
            fontSize: 14,
            textAlign: TextAlign.start,
          ),
        )
      ],
    );
  }
}
