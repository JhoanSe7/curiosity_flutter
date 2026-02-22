import 'package:curiosity_flutter/core/design/design.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomPageBuilder extends StatelessWidget {
  final Widget body;
  final bool enableAppbar;
  final String title;
  final bool enableScrollBar;
  final bool enableScrollable;
  final Color? titleColor;
  final Widget? customAppbar;
  final Widget? leading;
  final Widget? trailing;
  final Widget? customTitle;
  final bool centerTitle;
  final List<Color>? appbarColor;
  final Widget? bottomBar;
  final ScrollController? scrollController;

  const CustomPageBuilder({
    super.key,
    required this.body,
    this.enableAppbar = true,
    this.title = "",
    this.enableScrollBar = false,
    this.enableScrollable = true,
    this.titleColor,
    this.customAppbar,
    this.leading,
    this.trailing,
    this.customTitle,
    this.centerTitle = false,
    this.appbarColor,
    this.bottomBar,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            if (enableAppbar) customAppbar ?? appBar(context),
            Expanded(
              child: enableScrollable
                  ? enableScrollBar
                      ? Scrollbar(
                          thumbVisibility: true,
                          thickness: 10,
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: body,
                          ),
                        )
                      : SingleChildScrollView(
                          controller: scrollController,
                          child: body,
                        )
                  : body,
            ),
            bottomBar ?? SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(gradient: LinearGradient(colors: appbarColor ?? colors.gradientPrimary)),
      child: Row(
        mainAxisAlignment: centerTitle ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
        children: [
          if (leading != null)
            leading!
          else
            context.canPop()
                ? CustomCircularButton(
                    onTap: () => context.pop(),
                    icon: Icons.arrow_back,
                  )
                : SizedBox(width: 40, height: 40),
          if (!centerTitle) SizedBox(width: 16),
          customTitle ??
              Flexible(
                child: CustomText(
                  title,
                  color: titleColor ?? colors.white,
                  fontType: FontType.h2,
                ),
              ),
          trailing ?? SizedBox(width: 40, height: 40),
        ],
      ),
    );
  }
}
