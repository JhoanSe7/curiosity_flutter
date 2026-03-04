import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:curiosity_flutter/features/home/presentation/widgets/quizzes_view.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class QuizzesListView extends ConsumerStatefulWidget {
  const QuizzesListView({super.key});

  @override
  ConsumerState<QuizzesListView> createState() => _QuizzesListViewState();
}

class _QuizzesListViewState extends ConsumerState<QuizzesListView> {
  List<QuizModel> quizzes = [];
  List<QuizModel> filterList = [];
  final TextEditingController _filterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadData);
    _filterController.addListener(_onChange);
  }

  _loadData() {
    setState(() {
      quizzes = ref.read(homeController).quizzes;
      filterList = quizzes;
    });
  }

  _onChange() {
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
    return CustomPageBuilder(
      customTitle: titleWidget(quizzes.length),
      trailing: actions(),
      secondAppbar: Padding(
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
      body: QuizzesView(quizzes: filterList),
    );
  }

  Widget titleWidget(int length) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          "Mis Cuestionarios",
          color: colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        CustomText(
          length > 1 ? "$length cuestionarios creados" : "$length cuestionario creado",
          fontSize: 14,
          color: colors.white,
        ),
      ],
    );
  }

  Widget actions() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomCircularButton(
            icon: Icons.add,
            onTap: () => context.push(Routes.questionary),
          ),
        ],
      ),
    );
  }
}
