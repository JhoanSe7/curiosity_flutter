import 'package:curiosity_flutter/core/constants/config.dart';
import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/core/utils/extensions/text_extension.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:curiosity_flutter/features/room/data/models/quiz_result_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ResultsView extends ConsumerStatefulWidget {
  const ResultsView({super.key});

  @override
  ConsumerState<ResultsView> createState() => _ResultsViewState();
}

class _ResultsViewState extends ConsumerState<ResultsView> {
  List<QuizResultModel> get fakeResults => List.generate(
        5,
        (i) => QuizResultModel(
          id: 'ID$i',
          quizTitle: "Fake title",
          submittedAt: "2000-01-01",
          totalScore: 0.0,
        ),
      );

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(homeController.notifier).setLoading(true));
    Future.microtask(_loadData);
  }

  Future<void> _loadData() async {
    await ref.read(homeController.notifier).loadResults(context);
    ref.read(homeController.notifier).setLoading(false);
  }

  List<QuizResultModel> _loadList(List<QuizResultModel> results) {
    var tempList = List<QuizResultModel>.from(results);
    tempList.sort((a, b) {
      final dateA = DateTime.parse(a.submittedAt ?? "0");
      final dateB = DateTime.parse(b.submittedAt ?? "0");
      return dateB.compareTo(dateA);
    });
    return tempList;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeController);
    var list = _loadList(state.results);
    return Padding(
      padding: EdgeInsets.all(16),
      child: state.isLoading ? waitingResults(state.isLoading) : resultContent(list),
    );
  }

  Widget resultContent(List<QuizResultModel> list) {
    return Column(
      children: [
        if (list.isEmpty) emptyResult() else ...list.asMap().entries.map((e) => resultDetailCard(e.key, e.value)),
      ],
    );
  }

  Widget waitingResults(bool loading) {
    return Skeletonizer(
      enabled: loading,
      justifyMultiLineText: true,
      child: Column(
        children: fakeResults.asMap().entries.map((e) => resultDetailCard(e.key, e.value)).toList(),
      ),
    );
  }

  Widget emptyResult() {
    return Column(
      children: [
        CustomText(
          "Sin resultados",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        height.m,
        CustomText(
          "Cuando finalices un quiz, tus resultados se visualizaran aqui",
          fontSize: 14,
          color: colors.paragraph,
        ),
      ],
    );
  }

  Widget resultDetailCard(int index, QuizResultModel e) {
    return CustomGestureDetector(
      onTap: () => _onTapDetail(e),
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: Config.allColors[index % Config.allColors.length],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIcon(
                Icons.book_outlined,
                size: 30,
                color: colors.white,
              ),
            ),
            width.l,
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    e.quizTitle ?? "",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomIcon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: colors.iconPlaceholder,
                      ),
                      width.s,
                      Flexible(
                        child: CustomText(
                          (e.submittedAt ?? "").customDate,
                          fontSize: 14,
                          color: colors.paragraph,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            width.l,
            CustomText(
              "${(e.totalScore ?? 0).toInt()} pts",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.primary,
            ),
            CustomIcon(Icons.chevron_right_outlined, size: 25, color: colors.iconPlaceholder)
          ],
        ),
      ),
    );
  }

  void _onTapDetail(QuizResultModel e) {
    final controller = ref.read(homeController.notifier);
    controller.setResultDetail(e);
    context.push(Routes.resultDetail);
  }
}
