import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:curiosity_flutter/features/questionaries/presentation/widgets/quizzes_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'quiz_create_card_widget.dart';
import 'show_more_widget.dart';
import 'home_subtitle_widget.dart';

class QuizzesView extends ConsumerStatefulWidget {
  const QuizzesView({super.key, required this.quizzes, this.toHome = false});

  final List<QuizModel> quizzes;
  final bool toHome;

  @override
  ConsumerState<QuizzesView> createState() => _QuizzesViewState();
}

class _QuizzesViewState extends ConsumerState<QuizzesView> {
  List<String> filters = ["Todos", "Activos"];
  int selection = 0;
  List<QuizModel> quizList = [];

  List<QuizModel> _loadList(List<QuizModel> quizzes) {
    if (widget.toHome) {
      quizList = quizzes;
      return quizList.length > 10 ? quizList.sublist(0, 10) : quizList;
    } else {
      quizList = widget.quizzes;
      return quizList;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeController);
    var list = _loadList(state.quizzes);
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          topBar(),
          height.l,
          if (list.isNotEmpty)
            ...list.asMap().entries.map((e) => QuizzesCardWidget(e.key, e.value))
          else if (!widget.toHome)
            CustomText(
              'No se encontraron resultados',
              fontSize: 14,
            )
          else
            QuizCreateCardWidget(),
        ],
      ),
    );
  }

  Widget topBar() {
    return Row(
      children: [
        if (!widget.toHome)
          ...filters.asMap().entries.map(
                (e) => Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: CustomButton(
                    onTap: () => _setSelection(e.key),
                    text: e.value,
                    color: (selection == e.key ? colors.green : colors.white).withValues(alpha: .8),
                    textColor: selection == e.key ? colors.white : colors.paragraph,
                    height: 6,
                    fontSize: 12,
                  ),
                ),
              )
        else
          HomeSubtitleWidget("Mis Cuestionarios", Icons.menu_book, colors.purple),
        Spacer(),
        if (quizList.isNotEmpty && widget.toHome) ShowMoreWidget("Ver todos"),
      ],
    );
  }

  void _setSelection(int i) {
    setState(() {
      selection = i;
    });
  }
}
