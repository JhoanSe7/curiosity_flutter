import 'dart:math';

import 'package:curiosity_flutter/core/constants/config.dart';
import 'package:curiosity_flutter/features/auth/data/models/response/user_model.dart';
import 'package:curiosity_flutter/core/design/templates/waiting_list_widget.dart';
import 'package:curiosity_flutter/features/home/presentation/widgets/results/result_detail_card_widget.dart';
import 'package:curiosity_flutter/features/questionaries/data/models/quiz_model.dart';
import 'package:curiosity_flutter/features/questionaries/presentation/widgets/quizzes_card_widget.dart';
import 'package:curiosity_flutter/features/room/data/models/quiz_result_model.dart';
import 'package:curiosity_flutter/features/room/presentation/widgets/user_card_widget.dart';
import 'package:flutter/cupertino.dart';

extension FakeExtension on FakeList {
  List<Widget> get generate => switch (this) {
        FakeList.quiz => listQuiz.asMap().entries.map((e) => QuizzesCardWidget(e.key, e.value)).toList(),
        FakeList.result => listResult.asMap().entries.map((e) => ResultDetailCardWidget(e.key, e.value)).toList(),
        FakeList.user => listUser.asMap().entries.map((e) => UserCardWidget(e.key, e.value)).toList(),
      };

  List<QuizModel> get listQuiz => List.generate(
        4,
        (i) => QuizModel(
          id: 'ID$i',
          title: "Fake title",
          description: "Fake description",
        ),
      );

  List<QuizResultModel> get listResult => List.generate(
        4,
        (i) => QuizResultModel(
          id: 'ID$i',
          quizTitle: "Fake title",
          submittedAt: "2000-01-01",
          totalScore: 0.0,
        ),
      );

  List<UserModel> get listUser => List.generate(
        4,
        (i) => UserModel(
          id: 'ID$i',
          firstName: Config.fakeNames[Random().nextInt(Config.fakeNames.length)],
          lastName: Config.fakeLastNames[Random().nextInt(Config.fakeNames.length)],
          email: 'usuario$i@correo.co',
          score: Random().nextInt(1000).toDouble(),
        ),
      );
}
