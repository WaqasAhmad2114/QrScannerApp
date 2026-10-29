class UrlHelper {
  UrlHelper._();

  /// Returns a [Uri] only for valid http/https web links, otherwise null.
  /// QR content is untrusted: other schemes (tel:, intent:, javascript:,
  /// file: ...) are never treated as links.
  static Uri? parseWebUrl(String value) {
    final text = value.trim();
    if (text.isEmpty || RegExp(r'\s').hasMatch(text)) return null;
    final uri = Uri.tryParse(text);
    if (uri == null) return null;
    final isWeb = uri.scheme == 'http' || uri.scheme == 'https';
    if (isWeb && uri.host.isNotEmpty) return uri;
    return null;
  }
}
