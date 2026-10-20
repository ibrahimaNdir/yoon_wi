import 'package:yoon_wi/core/constants/transport_mode.dart';
import 'package:yoon_wi/core/error/exceptions.dart';
import 'package:yoon_wi/core/utils/json_parsers.dart';
import 'package:yoon_wi/features/networks/data/models/line_model.dart';
import 'package:yoon_wi/features/networks/domain/entities/transport_type.dart';

class TransportTypeModel extends TransportType {
  const TransportTypeModel({
    required super.name,
    required super.mode,
    required super.lines,
  });

  factory TransportTypeModel.fromJson(Map<String, dynamic> json) {
    final name = JsonParsers.string(json, 'type');
    final mode = TransportMode.fromLabel(name);
    if (mode == null) {
      throw LocalException('Type de transport inconnu : $name');
    }
    return TransportTypeModel(
      name: name,
      mode: mode,
      lines:
          JsonParsers.objects(json, 'lignes').map(LineModel.fromJson).toList(),
    );
  }
}
