import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';
import 'package:yoon_wi/features/search/domain/entities/search_preferences.dart';
import 'package:yoon_wi/features/search/domain/entities/trip_time.dart';
import 'package:yoon_wi/features/search/presentation/bloc/search_form_state.dart';

/// Formulaire de recherche partagé entre l'écran principal et les pages
/// de choix (lieu, heure, préférences). Enregistré comme singleton.
class SearchFormCubit extends Cubit<SearchFormState> {
  SearchFormCubit() : super(const SearchFormState());

  void setPlace(SearchField field, Place place) {
    emit(
      field == SearchField.from
          ? state.copyWith(departure: place)
          : state.copyWith(arrival: place),
    );
  }

  /// Un repère populaire remplit d'abord le départ, puis l'arrivée.
  void fillNextEmpty(Place place) {
    if (state.departure == null) {
      setPlace(SearchField.from, place);
    } else {
      setPlace(SearchField.to, place);
    }
  }

  void setTime(TripTime time) => emit(state.copyWith(time: time));

  void setPreferences(SearchPreferences preferences) =>
      emit(state.copyWith(preferences: preferences));

  /// Après un trajet terminé : nouvelle recherche, mêmes réglages.
  void clearPlaces() =>
      emit(SearchFormState(time: state.time, preferences: state.preferences));
}
