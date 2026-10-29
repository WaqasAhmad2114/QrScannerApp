import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../utils/size_utils.dart';
import 'common_text.dart';

/// Shared button. [outlined] gives the secondary style,
/// [color] overrides the fill color of the primary style.
class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.outlined = false,
    this.color = AppColors.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool outlined;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final height = context.hp(7).clamp(52.0, 64.0).toDouble();
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(context.wp(3.5)),
    );
    final padding = EdgeInsets.symmetric(horizontal: context.wp(2));
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: context.sp(20), color: AppColors.textPrimary),
          SizedBox(width: context.wp(2)),
        ],
        Flexible(
          child: CommonText(
            label,
            size: 16,
            weight: FontWeight.w600,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    return SizedBox(
      width: double.infinity,
      height: height,
      child: outlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                shape: shape,
                side: const BorderSide(color: AppColors.border),
                padding: padding,
              ),
              child: content,
            )
          : FilledButton(
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: color,
                disabledBackgroundColor: AppColors.surfaceLight,
                shape: shape,
                padding: padding,
              ),
              child: content,
            ),
    );
  }
}
