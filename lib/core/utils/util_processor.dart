import 'dart:async';

import 'package:curiosity_flutter/core/network/models/common_error.dart';
import 'package:curiosity_flutter/core/routes/routes.dart';
import 'package:curiosity_flutter/core/utils/utils.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

dynamic processError(BuildContext context, {required String error}) {
  context.showToast(text: error, type: MessageType.error);
  print(error);
}

Future<Either<CommonError, T>> execute<T>(BuildContext context, Future<Either<CommonError, T>> useCase) async {
  context.loading;
  final result = await useCase;
  navigatorKey.currentState?.pop();
  return result;
}
