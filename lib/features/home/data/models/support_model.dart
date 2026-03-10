class SupportModel {
  String? title;
  String? issuesType;
  String? description;

  SupportModel({
    this.title,
    this.issuesType,
    this.description,
  });

  factory SupportModel.fromJson(Map<String, dynamic> json) => SupportModel(
        title: json["title"],
        issuesType: json["issuesType"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "issuesType": issuesType,
        "description": description,
      };
}
