import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoon_wi/features/favorites/data/models/favorites_model.dart';
import 'package:yoon_wi/features/favorites/domain/entities/favorites.dart';

abstract class FavoritesLocalDataSource {
  Future<Favorites> read();
  Future<void> write(Favorites favorites);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  FavoritesLocalDataSourceImpl(this._prefs);
  final SharedPreferences _prefs;

  static const _key = 'favorites_v1';

  @override
  Future<Favorites> read() async {
    final raw = _prefs.getString(_key);
    if (raw == null) return Favorites.empty;
    try {
      return FavoritesModel.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
      );
    } catch (_) {
      // Données illisibles : on repart de zéro plutôt que de bloquer l'écran.
      return Favorites.empty;
    }
  }

  @override
  Future<void> write(Favorites favorites) async {
    await _prefs.setString(_key, jsonEncode(FavoritesModel.toJson(favorites)));
  }
}
