import 'dart:async';

import 'package:get/get.dart';

import '../routes/app_routes.dart';

class SplashController extends GetxController {
  Timer? _timer;

  @override
  void onReady() {
    super.onReady();
    // No camera permission is requested here.
    _timer = Timer(const Duration(milliseconds: 1500), () {
      Get.offAllNamed(AppRoutes.home);    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
