import 'package:equatable/equatable.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';
import 'package:yoon_wi/features/search/domain/entities/search_preferences.dart';
import 'package:yoon_wi/features/search/domain/entities/trip_time.dart';

enum SearchField { from, to }

class SearchFormState extends Equatable {
  const SearchFormState({
    this.departure,
    this.arrival,
    this.time = const TripTime(),
    this.preferences = const SearchPreferences(),
  });

  final Place? departure;
  final Place? arrival;
  final TripTime time;
  final SearchPreferences preferences;

  bool get samePlace =>
      departure != null && arrival != null && departure!.id == arrival!.id;

  bool get canSearch => departure != null && arrival != null && !samePlace;

  SearchFormState copyWith({
    Place? departure,
    Place? arrival,
    TripTime? time,
    SearchPreferences? preferences,
  }) {
    return SearchFormState(
      departure: departure ?? this.departure,
      arrival: arrival ?? this.arrival,
      time: time ?? this.time,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  List<Object?> get props => [departure, arrival, time, preferences];
}
