import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class ShareService {
  Future<void> shareText(String text);

  /// Renvoie false si WhatsApp n'a pas pu être ouvert.
  Future<bool> openWhatsApp(String text);

  Future<void> copy(String text);
}

class SharePlusShareService implements ShareService {
  @override
  Future<void> shareText(String text) async {
    // share_plus 11 et plus. Avec une version plus ancienne, remplace par :
    // await Share.share(text);
    await SharePlus.instance.share(ShareParams(text: text));
  }

  @override
  Future<bool> openWhatsApp(String text) async {
    final uri = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(text)}');
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> copy(String text) =>
      Clipboard.setData(ClipboardData(text: text));
}
