import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import 'common_text.dart';

class CommonSnackbar {
  CommonSnackbar._();

  static void show(String message, {bool isError = false}) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: CommonText(message, size: 14, maxLines: 3),
      backgroundColor: isError ? AppColors.error : AppColors.surfaceLight,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(Get.width * 0.04),
      borderRadius: Get.width * 0.03,
      duration: const Duration(seconds: 2),
    );
  }
}
