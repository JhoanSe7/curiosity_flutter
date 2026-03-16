import 'package:curiosity_flutter/core/constants/config.dart';
import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/core/utils/utils.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/option_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/question_data_type.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/question_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/question_type.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:curiosity_flutter/features/room/presentation/room_controller.dart';
import 'package:curiosity_flutter/features/room/presentation/room_state.dart';
import 'package:curiosity_flutter/features/room/presentation/widgets/countdown_overlay_timer.dart';
import 'package:curiosity_flutter/features/room/presentation/widgets/question_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class QuizFlowView extends ConsumerStatefulWidget {
  const QuizFlowView({super.key});

  @override
  ConsumerState<QuizFlowView> createState() => _QuizFlowViewState();
}

class _QuizFlowViewState extends ConsumerState<QuizFlowView> with SingleTickerProviderStateMixin {
  final _answerController = TextEditingController();
  List<OptionModel> options = [];
  bool? binarySelected;

  QuizModel? quiz;
  QuestionModel? question;
  int indexQuestion = 0;
  int timeReady = 3;
  bool showCountdown = true;
  bool starQuiz = false;

  List<QuestionModel> answers = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadData);
  }

  _loadData() {
    quiz = ref.read(roomController).quiz;
    var questions = quiz?.questions ?? [];
    if (questions.isEmpty) return;
    setState(() {
      question = questions.first;
      var data = _clearAnswer(question);
      answers.add(data ?? QuestionModel());
      _loadOptions();
    });
  }

  QuestionModel? _clearAnswer(QuestionModel? answer) {
    answer?.correctAnswer = null;
    answer?.correctAnswerText = null;
    for (var opt in answer?.options ?? <OptionModel>[]) {
      opt.isCorrect = false;
    }
    return answer;
  }

  _loadOptions() {
    if ((question?.options ?? []).isNotEmpty) {
      var opt = question?.options ?? [];
      options = opt.asMap().entries.map((e) => OptionModel(code: e.key, text: e.value.text, id: e.value.id)).toList();
    }
  }

  QuestionDataType questionData(String type) => Config.questionsType.firstWhere((e) => e.type.name == type);

  @override
  Widget build(BuildContext context) {
    ref.listen(roomController, _forceFinishAndResult);
    var time = question?.timeLimit ?? 0;
    return CustomPageBuilder(
      trailing: timerQuestion(),
      centerTitle: true,
      leading: Container(
        decoration: BoxDecoration(
          color: colors.white,
          shape: BoxShape.circle,
        ),
        child: CustomCircularButton(
          icon: Icons.close,
          onTap: _leaveQuiz,
          color: colors.red,
        ),
      ),
      secondAppbar: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              "Pregunta ${indexQuestion + 1} de ${quiz?.questions?.length ?? 0}",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colors.white,
            ),
            height.m,
            if (time > 0 && starQuiz)
              QuestionTimer(
                indexQuestion: indexQuestion,
                timeLimit: time,
                onTimeFinished: _nextQuestion,
              ),
            height.l,
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors.gradientPrimary),
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
              color: colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              questionTypeBox(),
              height.xl,
              CustomText(
                question?.question ?? "",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.left,
              ),
              height.xl,
              if (starQuiz) questionTypeOption(),
            ],
          ),
        ),
      ),
      overlay: showCountdown ? CountdownOverlayTimer(time: timeReady, onTimeFinished: _launchQuiz) : null,
      bottomBar: nextButton(),
    );
  }

  Widget timerQuestion() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: colors.white.withValues(alpha: .3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CustomIcon(
            Icons.access_time_outlined,
            size: 20,
            color: colors.white,
          ),
          width.s,
          CustomText(
            (question?.timeLimit ?? 0).toTime(),
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colors.white,
          ),
        ],
      ),
    );
  }

  Widget questionTypeBox() {
    var type = question?.type ?? "";
    if (type.isEmpty) return SizedBox.shrink();
    var obj = questionData(type);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: obj.color.first.withValues(alpha: .2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIcon(
            obj.icon,
            size: 20,
            color: obj.color.first,
          ),
          width.m,
          CustomText(
            obj.title,
            color: obj.color.first,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget questionTypeOption() {
    var type = QuestionType.values.firstWhere((e) => e.name == question?.type);
    switch (type) {
      case QuestionType.SINGLE_SELECTION:
        return simpleQuestion();
      case QuestionType.MULTIPLE_SELECTION:
        return multipleQuestion();
      case QuestionType.TRUE_FALSE:
        return binaryQuestion();
      case QuestionType.FILL_IN_THE_BLANK:
        return completeQuestion();
      case QuestionType.OPEN_ANSWER:
        return openQuestion();
    }
  }

  Widget simpleQuestion() => Column(
        children: options.map((e) => questionOption(e, () => _checkTap(e))).toList(),
      );

  Widget questionOption(OptionModel e, void Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: e.isCorrect ? colors.primary : colors.inputBorder, width: 2),
        ),
        child: Row(
          children: [
            Expanded(
              child: CustomText(
                e.text,
                textAlign: TextAlign.left,
                fontSize: 14,
              ),
            ),
            width.m,
            CustomIcon(
              e.isCorrect ? Icons.check_circle : Icons.circle_outlined,
              size: 24,
              color: e.isCorrect ? colors.primary : colors.inputBorder,
            ),
          ],
        ),
      ),
    );
  }

  Widget multipleQuestion() => Column(children: options.map((e) => questionOption(e, () => _checkAdd(e))).toList());

  Widget completeQuestion() => Column(
        children: [
          CustomTextField(
            text: "Escribe la respuesta correcta",
            controller: _answerController,
            onChange: _saveResponseText,
          ),
        ],
      );

  Widget binaryQuestion() => Column(
        children: [
          Row(
            children: [
              binaryButton("Verdadero", Icons.check, colors.primary, true),
              width.m,
              binaryButton("Falso", Icons.close, colors.red, false),
            ],
          ),
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

  Widget openQuestion() => Column(
        children: [
          CustomTextField(
            text: "Escribe tu respuesta",
            controller: _answerController,
            onChange: _saveResponseText,
          )
        ],
      );

  _saveResponseText(String text) {
    answers[indexQuestion].correctAnswerText = text;
  }

  _checkTap(OptionModel o) {
    if (mounted) {
      setState(() {
        for (int i = 0; i < options.length; i++) {
          var option = options[i];
          option.isCorrect = o.code == i ? !option.isCorrect : false;
          answers[indexQuestion].options?[i].isCorrect = o.code == i ? !option.isCorrect : false;
        }
      });
    }
  }

  _checkAdd(OptionModel e) {
    var option = options[e.code];
    if (mounted) {
      setState(() {
        option.isCorrect = !option.isCorrect;
        answers[indexQuestion].options?[e.code].isCorrect = option.isCorrect;
      });
    }
  }

  _binaryTap(bool value) {
    if (mounted) {
      setState(() {
        binarySelected = value;
        answers[indexQuestion].correctAnswer = value;
      });
    }
  }

  _nextQuestion() {
    indexQuestion++;
    if (indexQuestion < (quiz?.questions?.length ?? 0)) {
      setState(() {
        question = quiz?.questions?[indexQuestion];
        var data = _clearAnswer(question);
        answers.add(data ?? QuestionModel());
        _loadOptions();
        _answerController.text = "";
        showCountdown = true;
        starQuiz = false;
      });
    } else {
      _sendAnswers();
    }
  }

  _sendAnswers() {
    ref.read(roomController.notifier).emitMsg('/app/quiz.submit', _result());
    context.pushReplacement(Routes.finishQuiz);
  }

  _launchQuiz() {
    setState(() {
      showCountdown = false;
      starQuiz = true;
    });
  }

  Widget nextButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CustomButton(
        onTap: _nextQuestion,
        text: (quiz?.questions?.length ?? 0) > (indexQuestion + 1) ? "Siguiente" : "Finalizar",
        isGradient: true,
        gradientColor: colors.gradientPrimary,
        height: 18,
        large: true,
      ),
    );
  }

  _leaveQuiz() async {
    await context.showModal(
      title: "¿Estas seguro de que quieres abandonar el quiz?",
      content: "Se marcara el quiz como completado y se enviaran las preguntas aun no contestadas.",
      icon: Icons.warning,
      iconColor: colors.red,
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
              onTap: _onExit,
              height: 18,
              text: "Abandonar",
              color: colors.red,
            ),
          ),
        ],
      ),
    );
  }

  _onExit() {
    ref.read(roomController.notifier).emitMsg('/app/quiz.abandon', _result());
    ref.read(roomController.notifier).clearState();
    context.pop();
    context.go(Routes.home);
  }

  Map<String, dynamic> _result() {
    var user = ref.read(homeController).user ?? UserModel();
    var roomCode = ref.read(roomController).roomCode;
    return {
      "roomCode": roomCode,
      "quizId": quiz?.id,
      "user": user.toMap(),
      "answers": answers.map((e) => e.toJson()).toList(),
    };
  }

  _forceFinishAndResult(RoomState? previous, RoomState next) {
    if (previous?.forceFinish != true && next.forceFinish) {
      ref.read(roomController.notifier).emitMsg('/app/quiz.submit', _result());
      context.pushReplacement(Routes.finishQuiz);
    }
  }
}
