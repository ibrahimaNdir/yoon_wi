import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoon_wi/core/bloc/load_state.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/itinerary.dart';
import 'package:yoon_wi/features/itinerary/domain/usecases/find_itineraries.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';
import 'package:yoon_wi/features/search/domain/entities/search_preferences.dart';

class ItineraryCubit extends Cubit<LoadState<List<Itinerary>>> {
  ItineraryCubit(
    this._find, {
    this.minLoading = const Duration(milliseconds: 600),
  }) : super(const LoadState.loading());

  final FindItineraries _find;

  /// Le calcul est quasi instantané : on garde l'écran de chargement un
  /// court instant pour que l'utilisateur voie que la recherche a lieu.
  final Duration minLoading;

  int _sequence = 0;

  Future<void> search({
    required Place from,
    required Place to,
    required SearchPreferences preferences,
  }) async {
    final current = ++_sequence;
    emit(const LoadState.loading());

    final stopwatch = Stopwatch()..start();
    final result = await _find(
      FindItinerariesParams(from: from, to: to, preferences: preferences),
    );
    final remaining = minLoading - stopwatch.elapsed;
    if (remaining > Duration.zero) await Future<void>.delayed(remaining);

    // L'écran a pu être fermé, ou une recherche plus récente a démarré.
    if (isClosed || current != _sequence) return;

    result.fold(
      (failure) => emit(LoadState.failure(failure.message)),
      (itineraries) => emit(LoadState.success(itineraries)),
    );
  }
}
