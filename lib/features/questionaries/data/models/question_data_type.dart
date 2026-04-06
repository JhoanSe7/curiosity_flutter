import 'package:flutter/material.dart';

import 'question_type.dart';

class QuestionDataType {
  String title;
  String subtitle;
  List<Color> color;
  IconData icon;
  QuestionType type;

  QuestionDataType(this.title, this.subtitle, this.color, this.icon, this.type);
}
