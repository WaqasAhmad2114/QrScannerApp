import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../utils/size_utils.dart';

/// Shared text widget. Use this instead of raw Text / SelectableText.
class CommonText extends StatelessWidget {
  const CommonText(
    this.text, {
    super.key,
    this.size = 16,
    this.weight = FontWeight.w400,
    this.color = AppColors.textPrimary,
    this.align,
    this.maxLines,
    this.overflow,
    this.height,
    this.selectable = false,
  });

  final String text;
  final double size;
  final FontWeight weight;
  final Color color;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;
  final bool selectable;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: context.sp(size),
      fontWeight: weight,
      color: color,
      height: height,
    );
    if (selectable) {
      return SelectableText(text, style: style, textAlign: align);
    }
    return Text(
      text,
      style: style,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
