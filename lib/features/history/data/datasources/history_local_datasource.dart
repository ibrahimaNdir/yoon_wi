import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoon_wi/features/history/data/models/history_model.dart';
import 'package:yoon_wi/features/history/domain/entities/trip_history_entry.dart';

abstract class HistoryLocalDataSource {
  Future<List<TripHistoryEntry>> read();
  Future<void> write(List<TripHistoryEntry> entries);
}

class HistoryLocalDataSourceImpl implements HistoryLocalDataSource {
  HistoryLocalDataSourceImpl(this._prefs);
  final SharedPreferences _prefs;

  static const _key = 'history_v1';

  @override
  Future<List<TripHistoryEntry>> read() async {
    final raw = _prefs.getString(_key);
    if (raw == null) return [];
    try {
      final entries = <TripHistoryEntry>[];
      for (final item in jsonDecode(raw) as List) {
        try {
          entries.add(
            HistoryModel.fromJson(Map<String, dynamic>.from(item as Map)),
          );
        } catch (_) {
          // Une ligne illisible est ignorée, les autres sont gardées.
        }
      }
      return entries;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> write(List<TripHistoryEntry> entries) async {
    await _prefs.setString(
      _key,
      jsonEncode(entries.map(HistoryModel.toJson).toList()),
    );
  }
}
