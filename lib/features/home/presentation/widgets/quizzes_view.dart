import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:curiosity_flutter/core/design/templates/waiting_list_widget.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:curiosity_flutter/features/questionaries/presentation/widgets/quizzes_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'quizzes/quiz_create_card_widget.dart';

class QuizzesView extends ConsumerStatefulWidget {
  const QuizzesView({super.key});

  @override
  ConsumerState<QuizzesView> createState() => _QuizzesViewState();
}

class _QuizzesViewState extends ConsumerState<QuizzesView> {
  final TextEditingController _filterController = TextEditingController();
  List<QuizModel> quizzes = [];
  List<QuizModel> filterList = [];

  int selection = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadData);
    _filterController.addListener(_onChange);
  }

  Future<void> _loadData() async {
    final controller = ref.read(homeController.notifier);
    controller.setLoading(true);
    await controller.loadQuizzes(context);
    _loadList();
    controller.setLoading(false);
  }

  void _loadList() {
    setState(() {
      quizzes = ref.read(homeController).quizzes;
      filterList = quizzes;
    });
  }

  void _onChange() {
    setState(() {
      if (_filterController.text.trim().isEmpty) {
        _filterController.clear();
        filterList = quizzes;
        return;
      }
      filterList = quizzes
          .where((e) =>
              (e.title ?? "").toLowerCase().contains(_filterController.text.toLowerCase()) ||
              (e.description ?? "").toLowerCase().contains(_filterController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeController);
    return Column(
      children: [
        if (quizzes.isNotEmpty)
          Container(
            decoration: BoxDecoration(gradient: LinearGradient(colors: colors.gradientPrimary)),
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: CustomTextField(
              controller: _filterController,
              prefix: CustomIcon(
                Icons.search,
                color: colors.iconPlaceholder,
                size: 20,
              ),
              placeHolder: "Buscar cuestionario...",
              dense: true,
            ),
          ),
        if (state.isLoading)
          WaitingListWidget(loading: state.isLoading, list: FakeList.quiz)
        else
          Expanded(
            child: SingleChildScrollView(
              child: contentList(),
            ),
          ),
      ],
    );
  }

  Widget contentList() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          if (filterList.isNotEmpty)
            ...filterList.asMap().entries.map((e) => QuizzesCardWidget(e.key, e.value))
          else if (quizzes.isNotEmpty)
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
}
