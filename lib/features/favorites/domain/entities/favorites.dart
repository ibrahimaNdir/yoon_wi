import 'package:equatable/equatable.dart';
import 'package:yoon_wi/features/favorites/domain/entities/favorite_place.dart';
import 'package:yoon_wi/features/favorites/domain/entities/saved_trip.dart';

class Favorites extends Equatable {
  const Favorites({this.places = const [], this.trips = const []});

  static const empty = Favorites();

  final List<FavoritePlace> places;
  final List<SavedTrip> trips;

  bool isTripSaved(String fromId, String toId) =>
      trips.any((t) => t.id == '$fromId>$toId');

  Favorites copyWith({List<FavoritePlace>? places, List<SavedTrip>? trips}) =>
      Favorites(places: places ?? this.places, trips: trips ?? this.trips);

  @override
  List<Object> get props => [places, trips];
}
