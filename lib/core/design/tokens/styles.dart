import 'package:curiosity_flutter/core/design/design.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  TextStyle poppins({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextAlign? textAlign,
    FontType? fontType,
    List<Shadow>? shadows,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize ?? _getFontSize(fontType) ?? 16,
      fontWeight: fontWeight ?? _getFontWeight(fontType) ?? FontWeight.w400,
      color: color ?? colors.titles,
      decoration: TextDecoration.none,
      shadows: shadows,
    );
  }

  FontWeight? _getFontWeight(FontType? value) {
    var data = {
      FontType.h1: FontWeight.w500,
      FontType.h2: FontWeight.w500,
      FontType.h3: FontWeight.w500,
      FontType.h4: FontWeight.w400,
      FontType.h5: FontWeight.w400,
      FontType.h6: FontWeight.w400,
      FontType.b: FontWeight.w500,
    };
    return data[value];
  }

  double? _getFontSize(FontType? value) {
    var data = {
      FontType.h1: 24.0,
      FontType.h2: 20.0,
      FontType.h3: 18.0,
      FontType.h4: 18.0,
      FontType.h5: 16.0,
      FontType.h6: 14.0,
      FontType.b: 16.0,
    };
    return data[value];
  }
}

final styles = Styles();

enum FontType {
  h1,
  h2,
  h3,
  h4,
  h5,
  h6,
  b,
}

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
