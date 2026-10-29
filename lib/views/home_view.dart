import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common_widgets/common_button.dart';
import '../common_widgets/common_text.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../routes/app_routes.dart';
import '../utils/size_utils.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final illustration = context.wp(46);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.wp(6)),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: illustration,
                height: illustration,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.border),
                ),
                child: Icon(Icons.qr_code_scanner_rounded,
                    size: illustration * 0.5, color: AppColors.primary),
              ),
              SizedBox(height: context.hp(5)),
              const CommonText(AppStrings.appName,
                  size: 30, weight: FontWeight.w700, align: TextAlign.center),
              SizedBox(height: context.hp(1.5)),
              const CommonText(
                AppStrings.homeTagline,
                size: 16,
                color: AppColors.textSecondary,
                align: TextAlign.center,
              ),
              const Spacer(flex: 3),
              CommonButton(
                label: AppStrings.scanQrCode,
                icon: Icons.qr_code_scanner_rounded,
                onPressed: () => Get.toNamed<void>(AppRoutes.scanner),
              ),
              SizedBox(height: context.hp(3)),
            ],
          ),
        ),
      ),
    );
  }
}
