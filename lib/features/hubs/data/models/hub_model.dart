import 'package:yoon_wi/core/constants/transport_mode.dart';
import 'package:yoon_wi/core/error/exceptions.dart';
import 'package:yoon_wi/core/utils/json_parsers.dart';
import 'package:yoon_wi/features/hubs/domain/entities/hub.dart';

TransportMode _mode(String label) {
  final mode = TransportMode.fromLabel(label);
  if (mode == null) throw LocalException('Réseau inconnu : $label');
  return mode;
}

class TransferModel extends Transfer {
  const TransferModel({
    required super.from,
    required super.to,
    required super.walkMinutes,
  });

  factory TransferModel.fromJson(Map<String, dynamic> json) {
    return TransferModel(
      from: _mode(JsonParsers.string(json, 'de')),
      to: _mode(JsonParsers.string(json, 'vers')),
      walkMinutes: JsonParsers.integer(json, 'marche_min'),
    );
  }
}

class HubModel extends Hub {
  const HubModel({
    required super.id,
    required super.name,
    required super.networks,
    required super.transfers,
  });

  factory HubModel.fromJson(Map<String, dynamic> json) {
    return HubModel(
      id: JsonParsers.string(json, 'id'),
      name: JsonParsers.string(json, 'nom'),
      networks: JsonParsers.strings(json, 'reseaux').map(_mode).toList(),
      transfers:
          JsonParsers.objects(
            json,
            'correspondances',
          ).map(TransferModel.fromJson).toList(),
    );
  }
}
