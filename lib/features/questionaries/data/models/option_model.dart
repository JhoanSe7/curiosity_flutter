class OptionModel {
  String text;
  bool isCorrect;
  int id;

  OptionModel({
    this.text = "",
    this.isCorrect = false,
    required this.id,
  });

  factory OptionModel.fromJson(int id, Map<String, dynamic> json) => OptionModel(
        text: json["text"],
        isCorrect: json["isCorrect"],
        id: id,
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "isCorrect": isCorrect,
      };

  OptionModel copyWith(String text) => OptionModel(text: text, isCorrect: isCorrect, id: id);
}
