import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import 'common_text.dart';

class CommonDialog {
  CommonDialog._();

  static Future<void> show({
    required String title,
    required String message,
    required String primaryLabel,
    required VoidCallback onPrimary,
    required String secondaryLabel,
  }) {
    return Get.dialog<void>(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Get.width * 0.05),
        ),
        title: CommonText(title, size: 18, weight: FontWeight.w700),
        content: CommonText(message, size: 14, color: AppColors.textSecondary),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: CommonText(secondaryLabel,
                size: 14, color: AppColors.textSecondary),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              onPrimary();
            },
            child: CommonText(primaryLabel,
                size: 14, weight: FontWeight.w600, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
