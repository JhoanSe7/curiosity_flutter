import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'user_card_widget.dart';

Logger log = Logger('UsersScoredListWidget');

class UsersScoredListWidget extends StatelessWidget {
  const UsersScoredListWidget({super.key, required this.users, this.onTap});

  final List<UserModel> users;
  final void Function(UserModel e)? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...getUsersList(users, true).asMap().entries.map(
              (e) => CustomGestureDetector(
                onTap: () => _onTap(e.value),
                child: UserCardWidget(
                  e.key,
                  e.value,
                  scored: true,
                  position: e.key + 1,
                ),
              ),
            ),
        Divider(),
        height.m,
        ...getUsersList(users, false).asMap().entries.map(
              (e) => CustomGestureDetector(
                onTap: () => _onTap(e.value),
                child: UserCardWidget(
                  e.key,
                  e.value,
                  scored: true,
                  position: e.key + 4,
                ),
              ),
            ),
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

  void _onTap(UserModel e) {
    try {
      onTap?.call(e);
    } catch (e) {
      log.info("Error tap: $e");
    }
  }
}
