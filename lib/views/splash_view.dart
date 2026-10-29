import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common_widgets/common_text.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../controllers/splash_controller.dart';
import '../utils/size_utils.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final logo = context.wp(30);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: logo,
              height: logo,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(logo * 0.28),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.accent],
                ),
              ),
              child: Icon(Icons.qr_code_scanner_rounded,
                  size: logo * 0.55, color: AppColors.white),
            ),
            SizedBox(height: context.hp(3)),
            const CommonText(AppStrings.appName,
                size: 28, weight: FontWeight.w700),
            SizedBox(height: context.hp(4)),
            SizedBox(
              width: context.sp(24),
              height: context.sp(24),
              child: const CircularProgressIndicator(strokeWidth: 2.5),
            ),
          ],
        ),
      ),
    );
  }
}
