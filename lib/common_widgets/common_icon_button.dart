import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../utils/size_utils.dart';

/// Round icon button with a 48+ tap target.
class CommonIconButton extends StatelessWidget {
  const CommonIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
    this.active = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final size = context.wp(13).clamp(48.0, 64.0).toDouble();
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: active ? AppColors.primary : AppColors.surface,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: size,
            height: size,
            child:
                Icon(icon, size: context.sp(24), color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}
