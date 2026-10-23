import 'package:yoon_wi/core/utils/json_parsers.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';

class PlaceModel extends Place {
  const PlaceModel({
    required super.id,
    required super.name,
    required super.zone,
    required super.isPopular,
    super.aliases,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: JsonParsers.string(json, 'id'),
      name: JsonParsers.string(json, 'nom'),
      zone: JsonParsers.string(json, 'zone'),
      isPopular: JsonParsers.boolean(json, 'populaire'),
      aliases: JsonParsers.strings(json, 'alias'),
    );
  }

  static Map<String, dynamic> toJson(Place p) => {
    'id': p.id,
    'nom': p.name,
    'zone': p.zone,
    'populaire': p.isPopular,
    'alias': p.aliases,
  };
}