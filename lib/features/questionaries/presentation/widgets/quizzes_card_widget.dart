import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/core/utils/extensions/message_extension.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/question_data_type.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/room_model.dart';
import 'package:curiosity_flutter/features/questionaries/presentation/questionary_controller.dart';
import 'package:curiosity_flutter/features/room/presentation/room_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class QuizzesCardWidget extends ConsumerStatefulWidget {
  final int index;
  final QuizModel quiz;

  const QuizzesCardWidget(this.index, this.quiz, {super.key});

  @override
  ConsumerState<QuizzesCardWidget> createState() => _QuizzesCardWidgetState();
}

class _QuizzesCardWidgetState extends ConsumerState<QuizzesCardWidget> {
  List<Color> allColors = [
    colors.blue,
    colors.green,
    colors.orange,
    colors.purple,
  ];

  QuestionDataType questionData(String type) =>
      ref.read(questionaryController.notifier).element.firstWhere((e) => e.type.name == type);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: allColors[widget.index % allColors.length], offset: Offset(0, -5)),
          BoxShadow(color: colors.greyLight.withValues(alpha: .5), offset: Offset(0, 2), blurRadius: 10),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Flexible(child: titleQuiz(widget.quiz)), moreOptions(widget.quiz)],
          ),
          CustomText(
            widget.quiz.description ?? "",
            textAlign: TextAlign.start,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: colors.paragraph,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children:
                widget.quiz.questions?.map((e) => e.type).toSet().map((e) => iconQuestion(e ?? "")).toList() ?? [],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              questionsSizeText(widget.quiz),
              CustomButton(
                height: 6,
                color: allColors[widget.index % allColors.length],
                onTap: _startQuiz,
                child: Row(
                  children: [
                    CustomIcon(
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
              )
            ],
          )
        ],
      ),
    );
  }

  Widget titleQuiz(QuizModel q) {
    return Row(
      children: [
        Flexible(
          child: CustomText(
            q.title ?? "",
            fontSize: 16,
            fontWeight: FontWeight.w700,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        width.m,
        statusQuiz()
      ],
    );
  }

  Widget statusQuiz() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(
        color: colors.green.withValues(alpha: .2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: CustomText(
        "Activo",
        color: colors.green,
        fontWeight: FontWeight.w600,
        fontSize: 12,
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
              CustomIcon(
                Icons.edit,
                size: 20,
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
              CustomIcon(
                Icons.delete_forever_outlined,
                size: 20,
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
        CustomIcon(
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

  Widget iconQuestion(String type) {
    return Container(
      padding: EdgeInsets.all(6),
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: colors.whiteSmoke,
      ),
      child: CustomIcon(
        questionData(type).icon,
        color: questionData(type).color.first,
        size: 18,
      ),
    );
  }

  _startQuiz() async {
    var user = ref.read(homeController).user;
    var data = RoomModel(
      quizId: widget.quiz.id,
      hostId: user?.id,
      hostFirstName: user?.firstName,
      hostLastName: user?.lastName,
    );
    var res = await ref.read(questionaryController.notifier).createRoom(context, data: data);
    String roomCode = res.roomCode ?? "";
    if (roomCode.isNotEmpty) {
      ref.read(roomController.notifier).setRoomCode(roomCode);
      if (mounted) context.push(Routes.room);
    } else {
      if (mounted) {
        context.showToast(
          text: "No se pudo iniciar el quiz, intenta de nuevo más tarde.",
          type: MessageType.warning,
        );
      }
    }
  }
}

enum Option {
  edit,
  delete,
}
