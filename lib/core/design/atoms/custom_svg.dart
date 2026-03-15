import 'package:curiosity_flutter/core/design/design.dart';
import 'package:curiosity_flutter/core/utils/extensions/dimension_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSvg extends StatelessWidget {
  const CustomSvg(
    this.path, {
    super.key,
    this.color,
    this.size,
    this.width,
    this.height,
  });

  final String path;
  final Color? color;
  final double? size;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      width: context.scale(width ?? size),
      height: context.scale(height ?? size),
      colorFilter: ColorFilter.mode(
        color ?? colors.white,
        BlendMode.srcIn,
      ),
      placeholderBuilder: (_) => CustomIcon(
        Icons.image,
        color: colors.white,
        size: (size ?? 0) / 2,
      ),
    );
  }
}
