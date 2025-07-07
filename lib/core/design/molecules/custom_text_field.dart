import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final Widget? suffix;
  final String? label;
  final bool enable;
  final bool password;
  final Function()? onTapSuffix;

  const CustomTextField({
    super.key,
    this.controller,
    this.suffix,
    this.label,
    this.enable = true,
    this.password = false,
    this.onTapSuffix,
  });

  @override
  State<CustomTextField> createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  FocusNode focusNode = FocusNode();
  bool hideText = false;

  @override
  void initState() {
    super.initState();
    hideText = widget.password;
    focusNode.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (widget.label ?? "").isEmpty ? 48 : 56,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(12, 0, widget.password ? 10 : 0, 0),
      decoration: BoxDecoration(
        color: colors.inputPlaceholder,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.all(
          color: widget.enable && focusNode.hasFocus ? colors.mainGreen : colors.inputBorder,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: focusNode,
              cursorColor: colors.mainGreen,
              obscureText: hideText,
              onTapOutside: (v) => FocusScope.of(context).requestFocus(FocusNode()),
              controller: widget.controller,
              keyboardType: TextInputType.text,
              enabled: widget.enable,
              inputFormatters: InputFilters.email(),
              maxLines: 1,
              style: styles.poppins(color: colors.paragraph, fontType: FontType.h6),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                label: _labelWidget(),
              ),
            ),
          ),
          styles.w(Size.m),
          CustomGestureDetector(
            onTap: widget.password ? _showPasswd : widget.onTapSuffix,
            child: widget.suffix ??
                (widget.password
                    ? Icon(
                        hideText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: colors.iconPlaceholder,
                      )
                    : SizedBox()),
          ),
        ],
      ),
    );
  }

  void _showPasswd() {
    setState(() {
      hideText = !hideText;
    });
  }

  Widget? _labelWidget() {
    var text = widget.label ?? "";
    if (text.isNotEmpty) {
      return CustomText(text, color: colors.paragraph, maxLines: 1);
    }
    return null;
  }
}
