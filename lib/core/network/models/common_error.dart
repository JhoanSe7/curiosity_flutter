class CommonError {
  String message;

  CommonError({required this.message});

  factory CommonError.copyWith({required String message}) => CommonError(message: message);
}
