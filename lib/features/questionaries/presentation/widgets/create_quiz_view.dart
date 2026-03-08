import 'package:curiosity_flutter/core/constants/config.dart';
import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/core/utils/extensions/message_extension.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/question_data_type.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/question_model.dart';
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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _desController = TextEditingController();

  String textError = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadData);
  }

  _loadData() {
    var state = ref.read(questionaryController);
    if (state.quiz != null || state.quiz?.title != null) {
      _titleController.text = state.quiz?.title ?? "";
      _desController.text = state.quiz?.description ?? "";
      ref.read(questionaryController.notifier).setQuestions(state.quiz?.questions);
    }
  }

  QuestionDataType questionData(QuestionModel q) => Config.questionsType.firstWhere((e) => e.type.name == q.type);

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
              label: "Título del quiz",
              placeHolder: "Escribe el titulo del quiz",
              controller: _titleController,
              textError: textError,
              onChange: (_) => setState(() => textError = ""),
            ),
            height.l,
            CustomTextField(
              label: "Descripcion",
              placeHolder: "Escribe una descripcion del quiz",
              controller: _desController,
              maxLines: 3,
              inputType: TextInputType.multiline,
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
              onTap:  _questionTypeBottomSheet,
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
    var q = questions.length;
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
            "$q ${q > 1 ? "preguntas" : "pregunta"}",
            fontSize: 14,
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
    final quiz = ref.read(questionaryController).quiz;
    var data = quiz ?? QuizModel()
      ..userId = ref.read(homeController).user?.id
      ..title = _titleController.text
      ..description = _desController.text
      ..questions = ref.read(questionaryController).questions;
    var res = await ref.read(questionaryController.notifier).createQuiz(context, data: data);
    if ((res.id ?? "").isNotEmpty) {
      if (mounted) context.showToast(text: "Quiz creado con exito");
    }
    if (mounted) context.pop();
  }

  bool _validateButton() {
    final questions = ref.watch(questionaryController).questions;
    bool textEmpty = _titleController.text.isEmpty;
    bool questionEmpty = questions.isEmpty;
    if (questionEmpty) context.showToast(text: "Debe agregar al menos una pregunta", type: MessageType.error);
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
            child: CustomIcon(
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
                  fontSize: 14,
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
            icon: Icons.edit,
            color: colors.aquamarine,
            onTap: () => _editQuestion(q),
          ),
          CustomCircularButton(
            icon: Icons.delete_forever_outlined,
            color: colors.red,
            onTap: () => _showDeleteModal(q),
          )
        ],
      ),
    );
  }

  _editQuestion(QuestionModel q) {
    ref.read(questionaryController.notifier).setQuestion(q);
    ref.read(questionaryController.notifier).setQuestionType(questionData(q));
    context.push(Routes.createQuestion);
  }

  _showDeleteModal(QuestionModel q) {
    return context.showModal(
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
    );
  }

  _deleteQuestion(QuestionModel q) {
    ref.read(questionaryController.notifier).deleteQuestion(q);
    context.pop();
    context.showToast(text: "Pregunta eliminada");
  }

  Future<void> _questionTypeBottomSheet() async {
    var element = Config.questionsType;
    await context.showBottomSheetModal(
      title: "Tipo de Pregunta",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: element.map((q) => questionTypeOption(q)).toList(),
      ),
    );
  }

  Widget questionTypeOption(QuestionDataType q) {
    return CustomGestureDetector(
      onTap: () => _newQuestion(q),
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
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
              child: CustomIcon(
                q.icon,
                color: colors.white,
                size: 30,
              ),
            ),
            width.m,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    q.title,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                  height.s,
                  CustomText(
                    q.subtitle,
                    fontSize: 14,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            SizedBox(
              child: CustomIcon(
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
    ref.read(questionaryController.notifier).clearQuestion();
    context.pop();
    context.push(Routes.createQuestion);
  }
}
