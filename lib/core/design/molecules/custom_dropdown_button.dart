import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/utils/extensions/dimension_extension.dart';
import 'package:flutter/material.dart';

class CustomDropdownButton extends StatefulWidget {
  final List<ItemModel> items;
  final String hintText;
  final Function(String?) onSelect;

  const CustomDropdownButton({
    super.key,
    required this.items,
    this.hintText = "Seleccione",
    required this.onSelect,
  });

  @override
  State<CustomDropdownButton> createState() => CustomDropdownButtonState();
}

class CustomDropdownButtonState extends State<CustomDropdownButton> {
  FocusNode focusNode = FocusNode();
  String? selected;

  @override
  void initState() {
    super.initState();
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
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: context.width,
      decoration: BoxDecoration(
        color: colors.inputPlaceholder,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: focusNode.hasFocus ? colors.yellow : colors.inputBorder),
      ),
      child: DropdownButton(
        focusNode: focusNode,
        value: selected,
        isExpanded: true,
        icon: CustomIcon(Icons.keyboard_arrow_down_rounded),
        iconEnabledColor: colors.iconPlaceholder,
        iconSize: 30,
        hint: CustomText(
          widget.hintText,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: colors.paragraph,
        ),
        // value: items.first.title,
        items: widget.items
            .map(
              (e) => DropdownMenuItem(
                value: e.value,
                child: _item(e),
              ),
            )
            .toList(),
        onChanged: (value) {
          widget.onSelect(value);
          setState(() {
            selected = value;
          });
        },
      ),
    );
  }

  _item(ItemModel item) {
    String subtitle = item.subtitle ?? "";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          item.title ?? "",
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
        if (subtitle.isNotEmpty)
          CustomText(
            subtitle,
            fontSize: 14,
          ),
      ],
    );
  }
}

class ItemModel {
  final String? value;
  final String? title;
  final String? subtitle;

  ItemModel({this.value, this.title, this.subtitle});
}
