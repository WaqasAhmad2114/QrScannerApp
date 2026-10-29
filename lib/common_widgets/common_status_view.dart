import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../utils/size_utils.dart';
import 'common_button.dart';
import 'common_text.dart';

/// Centered icon + title + message + action. Used for permission and
/// camera error states (kept inside the Scanner screen, no extra screens).
class CommonStatusView extends StatelessWidget {
  const CommonStatusView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: context.wp(8)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: context.sp(64), color: AppColors.accent),
            SizedBox(height: context.hp(3)),
            CommonText(title,
                size: 22, weight: FontWeight.w700, align: TextAlign.center),
            SizedBox(height: context.hp(1.5)),
            CommonText(message,
                size: 15,
                color: AppColors.textSecondary,
                align: TextAlign.center,
                height: 1.4),
            SizedBox(height: context.hp(4)),
            CommonButton(label: buttonLabel, onPressed: onPressed),
          ],
        ),
      ),
    );
  }
}
