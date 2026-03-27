import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/features/room/presentation/room_controller.dart';
import 'package:curiosity_flutter/features/room/presentation/widgets/user_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ScoredBoardView extends ConsumerStatefulWidget {
  const ScoredBoardView({super.key});

  @override
  ConsumerState<ScoredBoardView> createState() => _ScoredBoardViewState();
}

class _ScoredBoardViewState extends ConsumerState<ScoredBoardView> {
  // List<UserModel> get fakeUsers => List.generate(
  //       10,
  //       (i) => UserModel(
  //         id: 'ID$i',
  //         firstName: Config.fakeNames[Random().nextInt(Config.fakeNames.length)],
  //         lastName: Config.fakeLastNames[Random().nextInt(Config.fakeNames.length)],
  //         email: 'usuario$i@correo.co',
  //         score: Random().nextInt(1000).toDouble(),
  //       ),
  //     );

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(roomController);
    return CustomPageBuilder(
      trailing: actions(),
      title: "Clasificacion",
      centerTitle: true,
      enableLeading: false,
      appbarColor: colors.gradientSecondary,
      body: Column(
        children: [
          ...getUsersList(state.users, true).asMap().entries.map(
                (e) => UserCardWidget(
                  e.key,
                  e.value,
                  scored: true,
                  position: e.key + 1,
                ),
              ),
          Divider(),
          height.m,
          ...getUsersList(state.users, false).asMap().entries.map(
                (e) => UserCardWidget(
                  e.key,
                  e.value,
                  scored: true,
                  position: e.key + 4,
                ),
              ),
        ],
      ),
      bottomBar: Padding(
        padding: EdgeInsets.all(16),
        child: CustomButton(
          text: "Finalizar y salir",
          height: 16,
          large: true,
          color: colors.orange,
          onTap: () => context.pop(),
        ),
      ),
    );
  }

  Widget actions() {
    return Row(
      children: [
        CustomCircularButton(
          icon: Icons.save_alt,
          onTap: () {},
        )
      ],
    );
  }

  List<UserModel> getUsersList(List<UserModel> userList, bool top) {
    if (userList.isEmpty) return [];
    List<UserModel> list = List.from(userList);
    list.sort((a, b) => (a.score ?? 0).compareTo(b.score ?? 0));
    list = list.reversed.toList();
    return top
        ? list.length >= 3
            ? list.sublist(0, 3)
            : list
        : list.length > 3
            ? list.sublist(3, list.length)
            : [];
  }
}
