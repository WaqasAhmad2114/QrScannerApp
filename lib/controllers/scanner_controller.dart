import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common_widgets/common_dialog.dart';
import '../common_widgets/common_snackbar.dart';
import '../constants/app_config.dart';
import '../constants/app_strings.dart';
import '../routes/app_routes.dart';

enum CameraPermissionState { checking, granted, denied, permanentlyDenied }

class ScannerController extends GetxController with WidgetsBindingObserver {
  late final MobileScannerController camera;

  final Rx<CameraPermissionState> permission =
  Rx<CameraPermissionState>(CameraPermissionState.checking);
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
    camera = MobileScannerController(
      autoStart: false,
      formats: const [BarcodeFormat.qrCode],
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );
    // Any camera error (also those raised by the preview widget) shows the
    // retry state instead of a blank screen.
    camera.addListener(_onCameraValueChanged);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onReady() {
    super.onReady();
    // Ask for permission after the first frame is on screen.
    requestPermission();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    camera.removeListener(_onCameraValueChanged);
    camera.dispose();
    super.onClose();
  }

  void _onCameraValueChanged() {
    final error = camera.value.error;
    if (error == null || camera.value.isRunning) return;
    _setError(error);
  }

  void _setError(MobileScannerException e) {
    if (e.errorCode == MobileScannerErrorCode.controllerAlreadyInitialized) {
      return;
    }
    final base = e.errorCode == MobileScannerErrorCode.unsupported
        ? AppStrings.cameraUnsupported
        : AppStrings.cameraErrorMessage;
    final detail = e.errorDetails?.message ?? e.errorDetails?.details;
    cameraError.value = AppConfig.showErrorDetails
        ? '$base\n\n[${e.errorCode.name}] ${detail ?? ''}'
        : base;
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
    } catch (_) {
      permission.value = CameraPermissionState.denied;
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
    // Never run two start() calls at once (permission dialog + lifecycle
    // resume used to trigger a second start and caused a generic error).
    if (_starting || camera.value.isRunning) return;
    _starting = true;
    try {
      await camera.start();
      cameraError.value = null;
    } on MobileScannerException catch (e) {
      _setError(e);
    } catch (e) {
      cameraError.value = AppConfig.showErrorDetails
          ? '${AppStrings.cameraErrorMessage}\n\n$e'
          : AppStrings.cameraErrorMessage;
    } finally {
      _starting = false;
    }
  }

  Future<void> _stopCamera() async {
    try {
      await camera.stop();
    } catch (_) {
      // Already stopped.
    }
  }

  Future<void> retryCamera() async {
    cameraError.value = null;
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
    await Get.toNamed<void>(AppRoutes.result, arguments: value);
    // Back from Results (Scan Again or system back): scan a new code.
    _handled = false;
    if (permission.value == CameraPermissionState.granted) {
      await _startCamera();
    }
  }
}