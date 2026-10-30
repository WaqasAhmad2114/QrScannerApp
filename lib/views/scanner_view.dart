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

class ScannerView extends StatefulWidget {
  const ScannerView({super.key});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  late final ScannerController _c;

  @override
  void initState() {
    super.initState();
    // Fresh controller every time the screen opens (camera restarts cleanly).
    if (Get.isRegistered<ScannerController>()) {
      Get.delete<ScannerController>(force: true);
    }
    _c = Get.put(ScannerController());
  }

  @override
  void dispose() {
    // Releases the camera (controller.onClose disposes it).
    Get.delete<ScannerController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _c;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        // Read every observable here, once, so Obx always tracks them.
        final permission = c.permission.value;
        final error = c.cameraError.value;

        if (permission == CameraPermissionState.checking) {
          return const Center(child: CircularProgressIndicator());
        }
        if (permission == CameraPermissionState.denied) {
          return _withBackButton(
            context,
            CommonStatusView(
              icon: Icons.photo_camera_outlined,
              title: AppStrings.permissionTitle,
              message: AppStrings.permissionMessage,
              buttonLabel: AppStrings.allowCamera,
              onPressed: c.requestPermission,
            ),
          );
        }
        if (permission == CameraPermissionState.permanentlyDenied) {
          return _withBackButton(
            context,
            CommonStatusView(
              icon: Icons.no_photography_outlined,
              title: AppStrings.permissionTitle,
              message: AppStrings.permissionSettingsMessage,
              buttonLabel: AppStrings.openSettings,
              onPressed: c.openSettings,
            ),
          );
        }
        if (error != null) {
          return _withBackButton(
            context,
            CommonStatusView(
              icon: Icons.videocam_off_outlined,
              title: AppStrings.cameraErrorTitle,
              message: error,
              buttonLabel: AppStrings.retry,
              onPressed: c.retryCamera,
            ),
          );
        }
        return _buildScanner(context, c);
      }),
    );
  }

  Widget _withBackButton(BuildContext context, Widget child) {
    return Stack(
      children: [
        Positioned.fill(child: child),
        Positioned(
          top: 0,
          left: 0,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(context.wp(4)),
              child: CommonIconButton(
                icon: Icons.arrow_back_rounded,
                tooltip: AppStrings.backTooltip,
                onTap: Get.back,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScanner(BuildContext context, ScannerController c) {
    final frame = context.wp(68);
    final height = context.screenHeight;

    return Stack(
      children: [
        Positioned.fill(
          child: MobileScanner(
            controller: c.camera,
            onDetect: c.onDetect,
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(child: ScanFrameOverlay(frameSize: frame)),

        // Top bar: back + title
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
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
        ),

        // Helper text under the frame
        Positioned(
          left: context.wp(8),
          right: context.wp(8),
          top: height / 2 + frame / 2 + context.hp(3),
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
              valueListenable: c.camera,
              builder: (context, state, _) {
                if (!state.isInitialized ||
                    state.torchState == TorchState.unavailable) {
                  return const SizedBox.shrink();
                }
                final on = state.torchState == TorchState.on;
                return Align(
                  heightFactor: 1,
                  child: CommonIconButton(
                    icon: on ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                    active: on,
                    tooltip: AppStrings.torchTooltip,
                    onTap: c.toggleTorch,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}