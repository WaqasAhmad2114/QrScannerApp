import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../common_widgets/common_icon_button.dart';
import '../common_widgets/common_status_view.dart';
import '../common_widgets/common_text.dart';
import '../common_widgets/scan_frame_overlay.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../controllers/scanner_controller.dart';
import '../utils/size_utils.dart';

class ScannerView extends GetView<ScannerController> {
  const ScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        switch (controller.permission.value) {
          case CameraPermissionState.checking:
            return const Center(child: CircularProgressIndicator());
          case CameraPermissionState.denied:
            return _withBackButton(
              context,
              CommonStatusView(
                icon: Icons.photo_camera_outlined,
                title: AppStrings.permissionTitle,
                message: AppStrings.permissionMessage,
                buttonLabel: AppStrings.allowCamera,
                onPressed: controller.requestPermission,
              ),
            );
          case CameraPermissionState.permanentlyDenied:
            return _withBackButton(
              context,
              CommonStatusView(
                icon: Icons.no_photography_outlined,
                title: AppStrings.permissionTitle,
                message: AppStrings.permissionSettingsMessage,
                buttonLabel: AppStrings.openSettings,
                onPressed: controller.openSettings,
              ),
            );
          case CameraPermissionState.granted:
            return _buildScanner(context);
        }
      }),
    );
  }

  Widget _withBackButton(BuildContext context, Widget child) {
    return Stack(
      children: [
        child,
        SafeArea(
          child: Padding(
            padding: EdgeInsets.all(context.wp(4)),
            child: CommonIconButton(
              icon: Icons.arrow_back_rounded,
              tooltip: AppStrings.backTooltip,
              onTap: Get.back,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScanner(BuildContext context) {
    return Obx(() {
      final error = controller.cameraError.value;
      if (error != null) {
        return _withBackButton(
          context,
          CommonStatusView(
            icon: Icons.videocam_off_outlined,
            title: AppStrings.cameraErrorTitle,
            message: error,
            buttonLabel: AppStrings.retry,
            onPressed: controller.retryCamera,
          ),
        );
      }

      final frame = context.wp(68);
      return LayoutBuilder(builder: (context, box) {
        return Stack(
          children: [
            Positioned.fill(
              child: MobileScanner(
                controller: controller.camera,
                onDetect: controller.onDetect,
                fit: BoxFit.cover,
                // Surface camera failures instead of leaving a blank screen.
                errorBuilder: (context, error, child) => _withBackButton(
                  context,
                  CommonStatusView(
                    icon: Icons.videocam_off_outlined,
                    title: AppStrings.cameraErrorTitle,
                    message: error.errorCode ==
                        MobileScannerErrorCode.unsupported
                        ? AppStrings.cameraUnsupported
                        : AppStrings.cameraErrorMessage,
                    buttonLabel: AppStrings.retry,
                    onPressed: controller.retryCamera,
                  ),
                ),
              ),
            ),
            Positioned.fill(child: ScanFrameOverlay(frameSize: frame)),

            // Top bar: back + title
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(context.wp(4)),
                child: Row(
                  children: [
                    CommonIconButton(
                      icon: Icons.arrow_back_rounded,
                      tooltip: AppStrings.backTooltip,
                      onTap: Get.back,
                    ),
                    SizedBox(width: context.wp(4)),
                    const CommonText(AppStrings.scannerTitle,
                        size: 20, weight: FontWeight.w600),
                  ],
                ),
              ),
            ),

            // Helper text under the frame
            Positioned(
              left: context.wp(8),
              right: context.wp(8),
              top: box.maxHeight / 2 + frame / 2 + context.hp(3),
              child: const CommonText(
                AppStrings.scannerHint,
                size: 16,
                align: TextAlign.center,
              ),
            ),

            // Flashlight (only when the device has a torch)
            Positioned(
              left: 0,
              right: 0,
              bottom: context.hp(6),
              child: SafeArea(
                child: ValueListenableBuilder<MobileScannerState>(
                  valueListenable: controller.camera,
                  builder: (context, state, _) {
                    if (!state.isInitialized ||
                        state.torchState == TorchState.unavailable) {
                      return const SizedBox.shrink();
                    }
                    final on = state.torchState == TorchState.on;
                    return Center(
                      child: CommonIconButton(
                        icon: on
                            ? Icons.flash_on_rounded
                            : Icons.flash_off_rounded,
                        active: on,
                        tooltip: AppStrings.torchTooltip,
                        onTap: controller.toggleTorch,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      });
    });
  }
}