import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/utils/extensions/dimension_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
  final bool loadingPage;
  final Widget? secondAppbar;
  final bool enableLeading;
  final Color? bgColor;
  final Widget? overlay;
  final bool enablePadding;

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
    this.loadingPage = false,
    this.secondAppbar,
    this.enableLeading = true,
    this.bgColor,
    this.overlay,
    this.enablePadding = true,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            Column(
              children: [
                if (enableAppbar)
                  Skeletonizer(
                    enabled: loadingPage,
                    justifyMultiLineText: true,
                    child: customAppbar ?? appBar(context),
                  ),
                if (secondAppbar != null)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: appbarColor ?? colors.gradientPrimary),
                    ),
                    child: secondAppbar,
                  ),
                Expanded(
                  child: Padding(
                    padding: enablePadding ? EdgeInsets.all(context.scale(16) ?? 16) : EdgeInsets.zero,
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
                ),
                Skeletonizer(
                  enabled: loadingPage,
                  justifyMultiLineText: true,
                  child: bottomBar ?? SizedBox(),
                ),
              ],
            ),
            if (overlay != null) overlay!
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
          if (enableLeading)
            leading ??
                (context.canPop()
                    ? CustomCircularButton(
                        onTap: () => context.pop(),
                        icon: Icons.arrow_back,
                      )
                    : SizedBox(width: 40, height: 40))
          else
            SizedBox(width: 40, height: 40),
          if (!centerTitle) width.l,
          customTitle ??
              Flexible(
                child: CustomText(
                  title,
                  color: titleColor ?? colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          trailing ?? SizedBox(width: 40, height: 40),
        ],
      ),
    );
  }
}
