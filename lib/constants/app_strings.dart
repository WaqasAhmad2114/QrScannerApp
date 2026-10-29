class AppStrings {
  AppStrings._();

  static const String appName = 'QR Scanner';

  // Home
  static const String homeTagline = 'Scan QR codes quickly and easily.';
  static const String scanQrCode = 'Scan QR Code';

  // Scanner
  static const String scannerTitle = 'Scan QR Code';
  static const String scannerHint = 'Place the QR code inside the frame.';
  static const String torchTooltip = 'Toggle flashlight';
  static const String backTooltip = 'Back';
  static const String permissionTitle = 'Camera access needed';
  static const String permissionMessage =
      'QR Scanner uses your camera only to read QR codes. '
      'Nothing is recorded, stored or uploaded.';
  static const String allowCamera = 'Allow Camera';
  static const String openSettings = 'Open Settings';
  static const String permissionSettingsMessage =
      'Camera permission is turned off. Open Settings and allow camera '
      'access to scan QR codes.';
  static const String cancel = 'Cancel';
  static const String cameraErrorTitle = 'Camera unavailable';
  static const String cameraErrorMessage =
      'We could not start the camera. It may be in use by another app. '
      'Please close other camera apps and try again.';
  static const String cameraUnsupported =
      'This device does not support camera scanning.';
  static const String retry = 'Try Again';
  static const String unsupportedQr =
      'This QR code is empty or not supported. Try another one.';

  // Result
  static const String resultTitle = 'Scan Result';
  static const String typeLink = 'Web link';
  static const String typeText = 'Text';
  static const String emptyResult = 'This QR code has no readable content.';
  static const String copy = 'Copy';
  static const String share = 'Share';
  static const String openLink = 'Open Link';
  static const String scanAgain = 'Scan Again';
  static const String copied = 'Copied to clipboard';
  static const String linkOpenFailed = 'Could not open this link.';
}
