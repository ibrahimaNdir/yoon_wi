import 'package:yoon_wi/core/utils/json_parsers.dart';
import 'package:yoon_wi/features/networks/data/models/stop_model.dart';
import 'package:yoon_wi/features/networks/domain/entities/line.dart';

class LineModel extends Line {
  const LineModel({
    required super.code,
    required super.name,
    required super.fare,
    required super.stops,
    required super.waitMin,
    required super.waitMax,
    required super.hopMin,
    required super.hopMax,
  });

  factory LineModel.fromJson(Map<String, dynamic> json) {
    return LineModel(
      code: JsonParsers.string(json, 'code'),
      name: JsonParsers.string(json, 'nom'),
      fare: JsonParsers.integer(json, 'tarif', fallback: 0),
      stops: JsonParsers.strings(json, 'arrets').map(StopModel.new).toList(),
      waitMin: JsonParsers.integer(json, 'attente_min', fallback: 5),
      waitMax: JsonParsers.integer(json, 'attente_max', fallback: 12),
      hopMin: JsonParsers.integer(json, 'arret_min', fallback: 3),
      hopMax: JsonParsers.integer(json, 'arret_max', fallback: 5),
    );
  }
}
