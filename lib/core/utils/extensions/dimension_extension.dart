import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

extension Dimension on BuildContext {
  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  double? scale(num? value) {
    if (value == null) return null;
    try {
      return value / 360 * MediaQuery.of(this).size.width;
    } catch (e) {
      double height =
          (WidgetsBinding.instance.window.physicalSize.height / WidgetsBinding.instance.window.devicePixelRatio);
      double width =
          (WidgetsBinding.instance.window.physicalSize.height / WidgetsBinding.instance.window.devicePixelRatio);

      double factor = isTablet ? height * 9 / 19 : width;

      return value / 360 * factor;
    }
  }

  bool get isTablet {
    if (inch < 7) {
      return false;
    }

    final view = View.of(this);

    double devicePixelRatio = view.devicePixelRatio;
    ui.Size size = view.physicalSize;
    double width = size.width;
    double height = size.height;

    if (devicePixelRatio < 2 && (width >= 1000 || height >= 1000)) {
      return true;
    } else if (devicePixelRatio == 2 && (width >= 1920 || height >= 1920)) {
      return true;
    } else {
      return false;
    }
  }

  double get inch {
    double a = width;
    double b = height;
    return (sqrt(pow(a, 2) + pow(b, 2))) / 150;
  }
}
