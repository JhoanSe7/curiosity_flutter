import 'package:curiosity_flutter/core/design/design.dart';
import 'package:flutter/material.dart';

class CustomPageBuilder extends StatelessWidget {
  final Widget body;
  final bool enableAppbar;
  final String title;
  final bool enableScrollBar;
  final bool enableScrollable;

  const CustomPageBuilder({
    super.key,
    required this.body,
    this.enableAppbar = true,
    this.title = "",
    this.enableScrollBar = false,
    this.enableScrollable = true,
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
        body: enableScrollable
            ? enableScrollBar
                ? Scrollbar(
                    thumbVisibility: true,
                    thickness: 10,
                    child: SingleChildScrollView(child: body),
                  )
                : SingleChildScrollView(child: body)
            : body,
      ),
    );
  }
}
