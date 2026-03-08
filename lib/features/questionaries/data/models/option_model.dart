class OptionModel {
  String? id;
  String text;
  bool isCorrect;
  int code;

  OptionModel({
    this.text = "",
    this.isCorrect = false,
    this.id,
    required this.code,
  });

  factory OptionModel.fromJson(int code, Map<String, dynamic> json) => OptionModel(
        id: json["id"],
        text: json["text"],
        isCorrect: json["isCorrect"],
        code: code,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "isCorrect": isCorrect,
      };

  OptionModel copyWith(String text) => OptionModel(text: text, isCorrect: isCorrect, id: id, code: code);
}
