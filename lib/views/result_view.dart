import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common_widgets/common_button.dart';
import '../common_widgets/common_text.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../controllers/result_controller.dart';
import '../utils/size_utils.dart';

class ResultView extends StatelessWidget {
  const ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final controller = ResultController(args is String ? args : '');
    final isLink = controller.isLink;
    final isEmpty = controller.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const CommonText(AppStrings.resultTitle,
            size: 20, weight: FontWeight.w600),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.wp(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Content type chip
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.wp(3.5),
                  vertical: context.hp(0.8),
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(context.wp(6)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isLink ? Icons.link_rounded : Icons.notes_rounded,
                      size: context.sp(18),
                      color: AppColors.accent,
                    ),
                    SizedBox(width: context.wp(2)),
                    CommonText(
                      isLink ? AppStrings.typeLink : AppStrings.typeText,
                      size: 14,
                      weight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.hp(2)),

              // Selectable, scrollable content
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(context.wp(4)),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(context.wp(4)),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: SingleChildScrollView(
                    child: CommonText(
                      isEmpty ? AppStrings.emptyResult : controller.value,
                      size: 16,
                      height: 1.45,
                      selectable: true,
                      color: isEmpty
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: context.hp(2)),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: CommonButton(
                      label: AppStrings.copy,
                      icon: Icons.copy_rounded,
                      outlined: true,
                      onPressed: isEmpty ? null : controller.copy,
                    ),
                  ),
                  SizedBox(width: context.wp(3)),
                  Expanded(
                    child: CommonButton(
                      label: AppStrings.share,
                      icon: Icons.ios_share_rounded,
                      outlined: true,
                      onPressed: isEmpty ? null : controller.share,
                    ),
                  ),
                ],
              ),
              if (isLink) ...[
                SizedBox(height: context.hp(1.5)),
                CommonButton(
                  label: AppStrings.openLink,
                  icon: Icons.open_in_new_rounded,
                  color: AppColors.accent,
                  onPressed: controller.openLink,
                ),
              ],
              SizedBox(height: context.hp(1.5)),
              CommonButton(
                label: AppStrings.scanAgain,
                icon: Icons.qr_code_scanner_rounded,
                onPressed: controller.scanAgain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}