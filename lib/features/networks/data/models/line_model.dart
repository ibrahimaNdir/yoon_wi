import 'package:yoon_wi/core/utils/json_parsers.dart';
import 'package:yoon_wi/features/networks/data/models/stop_model.dart';
import 'package:yoon_wi/features/networks/domain/entities/line.dart';

class LineModel extends Line {
  const LineModel({
    required super.code,
    required super.name,
    required super.fare,
    required super.stops,
  });

  factory LineModel.fromJson(Map<String, dynamic> json) {
    return LineModel(
      code: JsonParsers.string(json, 'code'),
      name: JsonParsers.string(json, 'nom'),
      fare: JsonParsers.integer(json, 'tarif', fallback: 0),
      stops: JsonParsers.strings(json, 'arrets').map(StopModel.new).toList(),
    );
  }
}
