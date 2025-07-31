class HttpResponseModel {
  bool success;
  String? message;
  dynamic body;

  HttpResponseModel({required this.success, this.message, this.body});

  factory HttpResponseModel.fromJson(Map<String, dynamic> json) => HttpResponseModel(
        success: json["success"],
        message: json["message"],
        body: json["body"],
      );
}
