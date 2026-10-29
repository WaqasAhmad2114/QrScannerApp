import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common_widgets/common_snackbar.dart';
import '../constants/app_strings.dart';
import '../utils/url_helper.dart';

class ResultController extends GetxController {
  late final String value;
  late final Uri? webUri;

  bool get isEmpty => value.trim().isEmpty;
  bool get isLink => webUri != null;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    value = args is String ? args : '';
    webUri = UrlHelper.parseWebUrl(value);
  }

  Future<void> copy() async {
    if (isEmpty) return;
    await Clipboard.setData(ClipboardData(text: value));
    CommonSnackbar.show(AppStrings.copied);
  }

  Future<void> share() async {
    if (isEmpty) return;
    await Share.share(value);
  }

  /// Only called from an explicit tap, never automatically.
  Future<void> openLink() async {
    final uri = webUri;
    if (uri == null) return;
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok) CommonSnackbar.show(AppStrings.linkOpenFailed, isError: true);
    } catch (_) {
      CommonSnackbar.show(AppStrings.linkOpenFailed, isError: true);
    }
  }

  void scanAgain() => Get.back<void>();
}
