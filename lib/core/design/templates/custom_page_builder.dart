import 'package:curiosity_flutter/core/design/design.dart';
import 'package:flutter/material.dart';

class CustomPageBuilder extends StatelessWidget {
  final Widget body;
  final bool enableAppbar;
  final String title;

  const CustomPageBuilder({
    super.key,
    required this.body,
    this.enableAppbar = true,
    this.title = "",
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: enableAppbar
            ? AppBar(
                title: CustomText(
                  title,
                  fontType: FontType.h2,
                  color: colors.titles,
                ),
              )
            : null,
        body: SingleChildScrollView(child: body),
      ),
    );
  }
}
