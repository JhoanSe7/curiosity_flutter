import 'package:curiosity_flutter/core/utils/utils.dart';
import 'package:flutter/material.dart';

T? processError<T>(BuildContext context, {required String error}) {
  context.showToast(text: error, error: true);
  print(error);
  return null;
}
