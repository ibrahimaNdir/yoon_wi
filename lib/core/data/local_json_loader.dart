import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:yoon_wi/core/error/exceptions.dart';

/// Lit un fichier JSON fourni avec l'application (dossier assets/).
class LocalJsonLoader {
  LocalJsonLoader({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

  Future<Map<String, dynamic>> loadMap(String path) async {
    final String raw;
    try {
      raw = await _bundle.loadString(path);
    } catch (_) {
      throw LocalException('Fichier introuvable : $path');
    }

    final dynamic decoded;
    try {
      decoded = jsonDecode(raw);
    } on FormatException {
      throw LocalException('JSON invalide : $path');
    }

    if (decoded is! Map<String, dynamic>) {
      throw LocalException('Format inattendu : $path');
    }
    return decoded;
  }
}
