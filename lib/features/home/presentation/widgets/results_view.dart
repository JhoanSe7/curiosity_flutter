import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/utils/extensions/dimension_extension.dart';
import 'package:curiosity_flutter/features/home/data/models/session_model.dart';
import 'package:curiosity_flutter/features/home/presentation/home_controller.dart';
import 'package:curiosity_flutter/features/home/presentation/widgets/results/result_detail_card_widget.dart';
import 'package:curiosity_flutter/core/design/templates/waiting_list_widget.dart';
import 'package:curiosity_flutter/features/room/data/models/quiz_result_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'results/session_detail_card_widget.dart';

class ResultsView extends ConsumerStatefulWidget {
  const ResultsView({super.key});

  @override
  ConsumerState<ResultsView> createState() => _ResultsViewState();
}

class _ResultsViewState extends ConsumerState<ResultsView> with TickerProviderStateMixin {
  late final TabController _tabController;

  List<QuizResultModel> resultList = [];
  List<SessionModel> sessionList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(_loadData);
  }

  Future<void> _loadData() async {
    final controller = ref.read(homeController.notifier);
    controller.setLoading(true);
    await _getResults();
    await _getSessions();
    setState(() {
      resultList = ref.read(homeController).results;
      sessionList = ref.read(homeController).sessions;
    });
    controller.setLoading(false);
  }

  Future<void> _getResults() async => await ref.read(homeController.notifier).loadResults(context);

  Future<void> _getSessions() async => await ref.read(homeController.notifier).loadSessions(context);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeController);
    return state.isLoading
        ? WaitingListWidget(
            loading: state.isLoading,
            list: FakeList.result,
          )
        : tabBarWidget();
  }

  Widget tabBarWidget() {
    return Column(
      children: [
        TabBar.secondary(
          controller: _tabController,
          dividerColor: colors.primary,
          indicatorColor: colors.orange,
          overlayColor: WidgetStatePropertyAll(colors.primary.withValues(alpha: .2)),
          padding: EdgeInsets.all(context.scale(16) ?? 16),
          tabs: [
            Tab(
              child: CustomText(
                "Mis resultados",
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Tab(
              child: CustomText(
                "Mis salas",
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(context.scale(16) ?? 16),
            child: TabBarView(
              controller: _tabController,
              children: [
                resultListWidget(),
                sessionListWidget(),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget resultListWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (resultList.isEmpty)
          emptyResult()
        else
          ...resultList.asMap().entries.map((e) => ResultDetailCardWidget(e.key, e.value))
      ],
    );
  }

  Widget sessionListWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (sessionList.isEmpty)
          emptyResult()
        else
          ...sessionList.asMap().entries.map((e) => SessionDetailCardWidget(e.key, e.value))
      ],
    );
  }

  Widget emptyResult() {
    return Column(
      children: [
        height.xl,
        CustomText(
          "Parece que no has realizado ningun quiz",
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        height.m,
        CustomText(
          "Cuando finalices un quiz, tus resultados y salas se visualizaran aqui",
          fontSize: 14,
          color: colors.paragraph,
        ),
      ],
    );
  }
}
