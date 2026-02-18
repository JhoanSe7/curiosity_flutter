import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/core/utils/extensions/dimension_extension.dart';
import 'package:curiosity_flutter/core/utils/extensions/message_extension.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/question_data_type.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/question_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/question_type.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:curiosity_flutter/features/questionaries/presentation/questionary_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateQuizView extends ConsumerStatefulWidget {
  const CreateQuizView({super.key});

  @override
  ConsumerState<CreateQuizView> createState() => _CreateQuizViewState();
}

class _CreateQuizViewState extends ConsumerState<CreateQuizView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();

  String textError = "";

  List<QuestionDataType> element = [
    QuestionDataType(
      "Selección Múltiple",
      "Varias respuestas correctas",
      colors.gradientPurple,
      Icons.check_box_outlined,
      QuestionType.MULTIPLE_SELECTION,
    ),
    QuestionDataType(
      "Única Selección",
      "Solo una respuesta correcta",
      colors.gradientBlue,
      Icons.circle_outlined,
      QuestionType.SINGLE_SELECTION,
    ),
    QuestionDataType(
      "Rellenar Espacios",
      "Completar la frase",
      colors.gradientYellow,
      Icons.square_outlined,
      QuestionType.FILL_IN_THE_BLANK,
    ),
    QuestionDataType(
      "Verdadero o Falso",
      "Pregunta de si o no",
      colors.gradientPrimary,
      Icons.help_outline_sharp,
      QuestionType.TRUE_FALSE,
    ),
    QuestionDataType(
      "Respuesta Abierta",
      "Respuesta libre",
      colors.gradientMagenta,
      Icons.description_outlined,
      QuestionType.OPEN_ANSWER,
    ),
  ];

  QuestionDataType questionData(QuestionModel q) => element.firstWhere((e) => e.type.name == q.type);

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(questionaryController);
    return CustomPageBuilder(
      customTitle: titleWidget(state.questions),
      trailing: actionButton(),
      enableScrollable: false,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(
              text: "Título del quiz",
              labelWeight: FontWeight.w600,
              controller: titleController,
              textError: textError,
            ),
            height.l,
            CustomTextField(
              placeHolder: "Descripcion breve",
              controller: desController,
              maxLines: 3,
            ),
            height.l,
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var q in state.questions.asMap().entries) ...[
                      questionCard(q.key, q.value),
                      height.l,
                    ],
                  ],
                ),
              ),
            ),
            height.l,
            CustomButton(
              width: 24,
              height: 12,
              isGradient: true,
              onTap: () => _questionTypeBottomSheet(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    color: colors.white,
                  ),
                  width.l,
                  CustomText(
                    "Agregar pregunta",
                    color: colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget titleWidget(List<QuestionModel> questions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          "Crear Quiz",
          color: colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        if (questions.isNotEmpty)
          CustomText(
            "${questions.length} preguntas",
            fontType: FontType.h6,
            color: colors.white,
          ),
      ],
    );
  }

  Widget actionButton() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomButton(
            onTap: _saveQuiz,
            text: "Guardar",
            color: colors.white.withValues(alpha: .3),
          ),
        ],
      ),
    );
  }

  _saveQuiz() async {
    bool empty = _validateButton();
    if (empty) return;
    var data = QuizModel(
      userId: ref.read(homeController).user?.id,
      title: titleController.text,
      description: desController.text,
      questions: ref.read(questionaryController).questions,
    );
    var res = await ref.read(questionaryController.notifier).createQuiz(context, data: data);
    if ((res.id ?? "").isNotEmpty) if (mounted) context.showToast(text: "Quiz creado con exito");
    if (mounted) context.pop();
  }

  bool _validateButton() {
    final questions = ref.watch(questionaryController).questions;
    bool textEmpty = titleController.text.isEmpty;
    bool questionEmpty = questions.isEmpty;
    if (questionEmpty) context.showToast(text: "Debe agregar al menos una pregunta", error: true);
    if (mounted) {
      setState(() {
        textError = textEmpty ? "Digite un titulo para el quiz" : "";
      });
    }
    return textEmpty || questionEmpty;
  }

  Widget questionCard(int index, QuestionModel q) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.inputBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: questionData(q).color,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(
              questionData(q).icon,
              color: colors.white,
              size: 25,
            ),
          ),
          width.l,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  "PREGUNTA ${index + 1}",
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: colors.paragraph,
                ),
                CustomText(
                  q.question ?? "",
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                ),
                height.m,
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: questionData(q).color,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).withOpacity(.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomText(
                    questionData(q).title,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
          width.l,
          CustomCircularButton(
            icon: Icons.delete_forever_outlined,
            color: colors.red,
            onTap: () => context.showModal(
              icon: Icons.delete_forever_outlined,
              iconColor: colors.red,
              title: "¿Elimar pregunta?",
              content: "Esta accion no se puede deshacer. La pregunta sera eliminada permanentemente.",
              actions: Row(
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
                      onTap: () => _deleteQuestion(q),
                      height: 18,
                      text: "Eliminar",
                      color: colors.red,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _deleteQuestion(QuestionModel q) {
    ref.read(questionaryController.notifier).deleteQuestion(q);
    context.pop();
    context.showToast(text: "Pregunta eliminada");
  }

  Future<void> _questionTypeBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          height: context.height,
          padding: EdgeInsets.all(16),
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  bottomSheetHeader(),
                  height.m,
                  Divider(),
                  height.m,
                  for (var q in element) ...[
                    questionTypeOption(q),
                    height.l,
                  ]
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget bottomSheetHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          "Tipo de Pregunta",
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: CustomCircularButton(
            icon: Icons.close,
            color: colors.grey,
            backgroundColor: colors.greyLight.withValues(alpha: .2),
            onTap: () => context.pop(),
          ),
        )
      ],
    );
  }

  Widget questionTypeOption(QuestionDataType q) {
    return CustomGestureDetector(
      onTap: () => _newQuestion(q),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.inputBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(colors: q.color, begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: Icon(
                q.icon,
                color: colors.white,
                size: 30,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    q.title,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 4),
                  CustomText(
                    q.subtitle,
                    fontType: FontType.h6,
                  ),
                ],
              ),
            ),
            SizedBox(
              child: Icon(
                Icons.arrow_forward_ios,
                color: colors.iconPlaceholder,
              ),
            )
          ],
        ),
      ),
    );
  }

  _newQuestion(QuestionDataType q) {
    ref.read(questionaryController.notifier).setQuestionType(q);
    context.push(Routes.createQuestion);
  }
}
