import 'package:flutter/cupertino.dart';

class OptionModel {
  String text;
  bool isCorrect;
  int id;
  TextEditingController controller;

  OptionModel({
    this.text = "",
    this.isCorrect = false,
    required this.id,
    required this.controller,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) => OptionModel(
        text: json["text"],
        isCorrect: json["isCorrect"],
        id: json["id"],
        controller: TextEditingController(),
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "isCorrect": isCorrect,
      };

  OptionModel withText() {
    text = controller.text;
    return this;
  }
}
