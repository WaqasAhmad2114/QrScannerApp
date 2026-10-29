import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common_widgets/common_dialog.dart';
import '../common_widgets/common_snackbar.dart';
import '../constants/app_strings.dart';
import '../routes/app_routes.dart';

enum CameraPermissionState { checking, granted, denied, permanentlyDenied }

class ScannerController extends GetxController with WidgetsBindingObserver {
  final MobileScannerController camera = MobileScannerController(
    autoStart: false,
    formats: const [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  final Rx<CameraPermissionState> permission =
      CameraPermissionState.checking.obs;
  final RxnString cameraError = RxnString();

  /// True from the first detection until the user returns from Results.
  /// Prevents duplicate scans/navigation from repeated camera frames.
  bool _handled = false;
  bool _requesting = false;
  bool _starting = false;
  DateTime _lastUnsupportedNotice = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    requestPermission();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    camera.dispose();
    super.onClose();
  }

  // ---------------------------------------------------------------- lifecycle

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _onResumed();
    } else if (permission.value == CameraPermissionState.granted) {
      _stopCamera();
    }
  }

  Future<void> _onResumed() async {
    if (_requesting) return;
    if (permission.value != CameraPermissionState.granted) {
      // User may have changed the permission in Settings.
      await _applyStatus(await Permission.camera.status);
    } else if (!_handled) {
      await _startCamera();
    }
  }

  // --------------------------------------------------------------- permission

  Future<void> requestPermission() async {
    if (_requesting) return;
    _requesting = true;
    try {
      var status = await Permission.camera.status;
      if (!status.isGranted && !status.isPermanentlyDenied) {
        status = await Permission.camera.request();
      }
      await _applyStatus(status, announce: true);
    } finally {
      _requesting = false;
    }
  }

  Future<void> _applyStatus(PermissionStatus status,
      {bool announce = false}) async {
    if (status.isGranted || status.isLimited) {
      final wasGranted = permission.value == CameraPermissionState.granted;
      permission.value = CameraPermissionState.granted;
      if (!wasGranted) {
        // Wait one frame so the MobileScanner widget exists before starting.
        WidgetsBinding.instance.addPostFrameCallback((_) => _startCamera());
      }
    } else if (status.isPermanentlyDenied || status.isRestricted) {
      permission.value = CameraPermissionState.permanentlyDenied;
      if (announce) {
        CommonDialog.show(
          title: AppStrings.permissionTitle,
          message: AppStrings.permissionSettingsMessage,
          primaryLabel: AppStrings.openSettings,
          onPrimary: openSettings,
          secondaryLabel: AppStrings.cancel,
        );
      }
    } else {
      permission.value = CameraPermissionState.denied;
    }
  }

  Future<void> openSettings() => openAppSettings();

  // ------------------------------------------------------------------- camera

  Future<void> _startCamera() async {
    // Guard against overlapping starts (permission callback + resume both
    // try to start the camera).
    if (_starting) return;
    _starting = true;
    try {
      await camera.start();
      cameraError.value = null;
    } on MobileScannerException catch (e) {
      if (e.errorCode == MobileScannerErrorCode.controllerAlreadyInitialized) {
        return;
      }
      cameraError.value = _messageFor(e);
    } catch (_) {
      cameraError.value = AppStrings.cameraErrorMessage;
    } finally {
      _starting = false;
    }
  }

  String _messageFor(MobileScannerException e) =>
      e.errorCode == MobileScannerErrorCode.unsupported
          ? AppStrings.cameraUnsupported
          : AppStrings.cameraErrorMessage;

  Future<void> _stopCamera() async {
    try {
      await camera.stop();
    } catch (_) {
      // Already stopped.
    }
  }

  Future<void> retryCamera() async {
    cameraError.value = null;
    await _stopCamera();
    await _startCamera();
  }

  Future<void> toggleTorch() async {
    try {
      await camera.toggleTorch();
    } catch (_) {
      CommonSnackbar.show(AppStrings.cameraErrorMessage, isError: true);
    }
  }

  // ---------------------------------------------------------------- detection

  void onDetect(BarcodeCapture capture) {
    if (_handled) return;

    String? value;
    for (final barcode in capture.barcodes) {
      final raw = barcode.rawValue;
      if (raw != null && raw.isNotEmpty) {
        value = raw;
        break;
      }
    }

    if (value == null) {
      _notifyUnsupported(capture.barcodes.isNotEmpty);
      return;
    }
    _openResult(value);
  }

  void _notifyUnsupported(bool detectedSomething) {
    if (!detectedSomething) return;
    final now = DateTime.now();
    if (now.difference(_lastUnsupportedNotice).inSeconds < 3) return;
    _lastUnsupportedNotice = now;
    CommonSnackbar.show(AppStrings.unsupportedQr, isError: true);
  }

  Future<void> _openResult(String value) async {
    _handled = true;
    await _stopCamera();
    try {
      await Get.toNamed<void>(AppRoutes.result, arguments: value);
    } finally {
      // Always reset, even if navigation fails, so scanning can't get stuck.
      _handled = false;
      if (permission.value == CameraPermissionState.granted) {
        await _startCamera();
      }
    }
  }
}