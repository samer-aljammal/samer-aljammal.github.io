import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens external links, mail and phone targets.
///
/// Failures are swallowed on purpose: a blocked popup or a machine with no mail
/// client shouldn't throw into the widget tree of a portfolio page.
abstract final class LinkLauncher {
  const LinkLauncher._();

  static Future<void> open(String url) => _launch(Uri.parse(url));

  static Future<void> email(String address, {String? subject}) => _launch(
    Uri(
      scheme: 'mailto',
      path: address,
      queryParameters: subject == null ? null : {'subject': subject},
    ),
  );

  static Future<void> phone(String number) =>
      _launch(Uri(scheme: 'tel', path: number));

  static Future<void> _launch(Uri uri) async {
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (error, stackTrace) {
      debugPrint('LinkLauncher failed for $uri: $error\n$stackTrace');
    }
  }
}
