import 'package:yoon_wi/core/error/exceptions.dart';

class JsonParsers {
  JsonParsers._();

  static String string(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is String) return value;
    throw LocalException('Champ texte manquant : $key');
  }

  static int integer(Map<String, dynamic> json, String key, {int? fallback}) {
    final value = json[key];
    if (value is num) return value.toInt();
    if (fallback != null) return fallback;
    throw LocalException('Champ nombre manquant : $key');
  }

  static bool boolean(
    Map<String, dynamic> json,
    String key, {
    bool fallback = false,
  }) {
    final value = json[key];
    return value is bool ? value : fallback;
  }

  static List<Map<String, dynamic>> objects(
    Map<String, dynamic> json,
    String key,
  ) {
    final value = json[key];
    if (value is List) {
      return value.whereType<Map<String, dynamic>>().toList();
    }
    throw LocalException('Liste manquante : $key');
  }

  static List<String> strings(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is List) return value.whereType<String>().toList();
    throw LocalException('Liste de textes manquante : $key');
  }
}
