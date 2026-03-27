import 'package:curiosity_flutter/core/design/design.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  TextStyle poppins({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextAlign? textAlign,
    List<Shadow>? shadows,
    Paint? foreground,
    double? height
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: foreground == null ? (color ?? colors.titles) : null,
      decoration: TextDecoration.none,
      shadows: shadows,
      foreground: foreground,
      height: height,
    );
  }
}

final styles = Styles();

class VerticalSpace {
  SizedBox get xs => SizedBox(height: 2.0);

  SizedBox get s => SizedBox(height: 4.0);

  SizedBox get m => SizedBox(height: 8.0);

  SizedBox get l => SizedBox(height: 16.0);

  SizedBox get xl => SizedBox(height: 32.0);
}

final height = VerticalSpace();

class HorizontalSpace {
  SizedBox get xs => SizedBox(width: 2.0);

  SizedBox get s => SizedBox(width: 4.0);

  SizedBox get m => SizedBox(width: 8.0);

  SizedBox get l => SizedBox(width: 16.0);

  SizedBox get xl => SizedBox(width: 32.0);
}

final width = HorizontalSpace();
