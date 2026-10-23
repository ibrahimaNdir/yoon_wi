import 'package:yoon_wi/core/utils/json_parsers.dart';
import 'package:yoon_wi/features/favorites/domain/entities/favorite_place.dart';
import 'package:yoon_wi/features/favorites/domain/entities/favorites.dart';
import 'package:yoon_wi/features/favorites/domain/entities/saved_trip.dart';
import 'package:yoon_wi/features/search/data/models/place_model.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';

/// Les favoris sont enregistrés avec une copie complète des lieux :
/// ils restent lisibles même si places.json change.
class FavoritesModel {
  FavoritesModel._();

  static Map<String, dynamic> placeToJson(Place p) => {
    'id': p.id,
    'nom': p.name,
    'zone': p.zone,
    'populaire': p.isPopular,
    'alias': p.aliases,
  };

  static Place _place(Object? raw) =>
      PlaceModel.fromJson(Map<String, dynamic>.from(raw! as Map));

  static Favorites fromJson(Map<String, dynamic> json) {
    return Favorites(
      places:
          JsonParsers.objects(json, 'lieux')
              .map(
                (o) => FavoritePlace(
                  label: JsonParsers.string(o, 'label'),
                  place: _place(o['lieu']),
                ),
              )
              .toList(),
      trips:
          JsonParsers.objects(json, 'trajets')
              .map(
                (o) => SavedTrip(
                  from: _place(o['depart']),
                  to: _place(o['arrivee']),
                ),
              )
              .toList(),
    );
  }

  static Map<String, dynamic> toJson(Favorites f) => {
    'lieux': [
      for (final p in f.places)
        {'label': p.label, 'lieu': placeToJson(p.place)},
    ],
    'trajets': [
      for (final t in f.trips)
        {'depart': placeToJson(t.from), 'arrivee': placeToJson(t.to)},
    ],
  };
}
