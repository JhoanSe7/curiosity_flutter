class ErrorResponseModel {
  //error
  String? message;
  String? errorCode;

  ErrorResponseModel({
    this.message,
    this.errorCode,
  });

  factory ErrorResponseModel.fromJson(Map<String, dynamic> json) => ErrorResponseModel(
        message: json["message"],
        errorCode: json["errorCode"],
      );
}
