import 'package:yoon_wi/core/error/exceptions.dart';
import 'package:yoon_wi/core/utils/json_parsers.dart';
import 'package:yoon_wi/features/history/domain/entities/trip_history_entry.dart';
import 'package:yoon_wi/features/search/data/models/place_model.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';

/// Les lieux sont copiés en entier : l'historique reste lisible même si
/// places.json change.
class HistoryModel {
  HistoryModel._();

  static Map<String, dynamic> toJson(TripHistoryEntry e) => {
    'depart': PlaceModel.toJson(e.from),
    'arrivee': PlaceModel.toJson(e.to),
    'tarif': e.fare,
    'min': e.minMinutes,
    'max': e.maxMinutes,
    'date': e.at.toIso8601String(),
  };

  static Place _place(Object? raw) =>
      PlaceModel.fromJson(Map<String, dynamic>.from(raw! as Map));

  static TripHistoryEntry fromJson(Map<String, dynamic> json) {
    final at = DateTime.tryParse(JsonParsers.string(json, 'date'));
    if (at == null) throw const LocalException('Date invalide.');
    return TripHistoryEntry(
      from: _place(json['depart']),
      to: _place(json['arrivee']),
      fare: JsonParsers.integer(json, 'tarif'),
      minMinutes: JsonParsers.integer(json, 'min'),
      maxMinutes: JsonParsers.integer(json, 'max'),
      at: at,
    );
  }
}
