import 'package:get/get.dart';

import '../controllers/splash_controller.dart';
import '../views/home_view.dart';
import '../views/result_view.dart';
import '../views/scanner_view.dart';
import '../views/splash_view.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String home = '/home';
  static const String scanner = '/scanner';
  static const String result = '/result';
}

class AppPages {
  AppPages._();

  static final List<GetPage<dynamic>> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: BindingsBuilder(() => Get.put(SplashController())),
    ),
    GetPage(name: AppRoutes.home, page: () => const HomeView()),
    GetPage(name: AppRoutes.scanner, page: () => const ScannerView()),
    GetPage(name: AppRoutes.result, page: () => const ResultView()),
  ];
}