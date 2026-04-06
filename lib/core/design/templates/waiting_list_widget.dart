import 'package:curiosity_flutter/core/utils/extensions/fake_extension.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart' show Skeletonizer;

class WaitingListWidget extends StatelessWidget {
  const WaitingListWidget({super.key, required this.loading, required this.list});

  final bool loading;
  final FakeList list;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: loading,
      justifyMultiLineText: true,
      child: Column(children: list.generate),
    );
  }
}

enum FakeList { quiz, result, user }
