import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoon_wi/core/bloc/load_state.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';
import 'package:yoon_wi/features/search/domain/usecases/search_places.dart';

class PlaceSearchCubit extends Cubit<LoadState<List<Place>>> {
  PlaceSearchCubit(this._searchPlaces) : super(const LoadState.loading());
  final SearchPlaces _searchPlaces;
  int _sequence = 0;

  Future<void> search(String query) async {
    final current = ++_sequence;
    final result = await _searchPlaces(query);
    if (current != _sequence) return; // une recherche plus récente existe
    result.fold(
      (failure) => emit(LoadState.failure(failure.message)),
      (places) => emit(LoadState.success(places)),
    );
  }
}
