import 'package:curiosity_flutter/core/design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final Widget? suffix;
  final String text;
  final bool enable;
  final bool password;
  final Function()? onTapSuffix;
  final Function()? onEdited;
  final Function(String)? onChange;
  final Function(String)? onSubmit;
  final TextInputType inputType;
  final String textError;
  final List<TextInputFormatter>? formatters;
  final String label;
  final IconData? iconLabel;
  final List<Color>? iconBackground;
  final bool showStrengthLevel;
  final FontWeight? labelWeight;
  final int maxLines;
  final String? placeHolder;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    this.controller,
    this.suffix,
    this.text = "",
    this.enable = true,
    this.password = false,
    this.onTapSuffix,
    this.onEdited,
    this.onChange,
    this.onSubmit,
    this.inputType = TextInputType.text,
    this.textError = "",
    this.formatters,
    this.label = "",
    this.iconLabel,
    this.iconBackground,
    this.showStrengthLevel = false,
    this.labelWeight,
    this.maxLines = 1,
    this.placeHolder,
    this.focusNode,
  });

  @override
  State<CustomTextField> createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  late final TextEditingController controller;
  late FocusNode focusNode;
  bool hideText = false;
  int level = 0;
  double? boxHeight;

  @override
  void initState() {
    super.initState();
    hideText = widget.password;
    boxHeight = (widget.text.isEmpty ? 48 : 56) + (widget.maxLines * 8);
    focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(() {
      if (mounted) setState(() {});
    });
    _initController();
  }

  _initController() {
    controller = widget.controller ?? TextEditingController();
    controller.addListener(
      () {
        _evaluatePassword(controller.text);
      },
    );
  }

  void _evaluatePassword(String password) {
    int lvl = 0;

    if (password.length >= 8) lvl++;
    if (RegExp(r'[A-Z]').hasMatch(password)) lvl++;
    if (RegExp(r'[0-9]').hasMatch(password)) lvl++;
    if (RegExp(r'[!@#\$&*~%^+=¿?_.,\-]').hasMatch(password)) lvl++;

    setState(() {
      level = lvl;
    });
  }

  @override
  void dispose() {
    controller.removeListener(() {});
    focusNode.removeListener(() {});
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.label.isNotEmpty) ...[
          CustomLabel(
            text: widget.label,
            icon: widget.iconLabel,
            iconBackground: widget.iconBackground ?? colors.gradientPrimary,
          ),
          height.m,
        ],
        Container(
          height: boxHeight,
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(12, 0, widget.password ? 10 : 0, 0),
          decoration: BoxDecoration(
            color: colors.inputPlaceholder,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            border: Border.all(
              color: widget.textError.isEmpty
                  ? widget.enable && focusNode.hasFocus
                      ? colors.primary
                      : colors.inputBorder
                  : colors.red,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  focusNode: focusNode,
                  cursorColor: colors.primary,
                  obscureText: hideText,
                  onTapOutside: (v) => FocusScope.of(context).requestFocus(FocusNode()),
                  onChanged: widget.onChange,
                  onSubmitted: widget.onSubmit,
                  onEditingComplete: widget.onEdited,
                  controller: controller,
                  keyboardType: widget.inputType,
                  enabled: widget.enable,
                  inputFormatters: widget.formatters,
                  maxLines: widget.maxLines,
                  minLines: widget.maxLines,
                  style: styles.poppins(color: colors.paragraph, fontType: FontType.h6),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    label: _labelWidget(),
                    hintText: widget.placeHolder,
                    hintStyle: styles.poppins(
                      color: colors.paragraph,
                    ),
                  ),
                ),
              ),
              width.m,
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
        ),
        if (widget.password && widget.showStrengthLevel && controller.text.isNotEmpty) ...[
          height.m,
          Row(
            children: List.generate(4, (i) {
              return Expanded(child: _itemLvl(i));
            }),
          ),
          height.m,
          Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              "Seguridad: ${_lvlText[level]}",
              fontType: FontType.b,
              color: level > 2 ? colors.green : colors.titles,
            ),
          ),
        ],
        if (widget.textError.isNotEmpty) ...[
          height.m,
          Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              widget.textError,
              color: colors.red,
              fontSize: 14,
            ),
          )
        ]
      ],
    );
  }

  void _showPasswd() {
    setState(() {
      hideText = !hideText;
    });
  }

  Widget? _labelWidget() {
    var text = widget.text;
    if (text.isNotEmpty) {
      return CustomText(
        text,
        color: colors.paragraph,
        maxLines: 1,
        fontWeight: widget.labelWeight,
      );
    }
    return null;
  }

  Widget _itemLvl(int index) {
    final bool active = index < level;
    return Container(
      margin: EdgeInsets.only(right: index < 3 ? 4 : 0),
      height: 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: active ? _lvlColor[level] : colors.inactiveButton,
      ),
    );
  }

  final List<Color> _lvlColor = [
    colors.inactiveButton,
    colors.red,
    colors.orange,
    colors.yellow,
    colors.green,
  ];

  final List<String> _lvlText = [
    "Muy débil",
    "Débil",
    "Regular",
    "Buena",
    "¡Excelente!",
  ];
}
