import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoon_wi/core/bloc/load_state.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/core/usecases/usecase.dart';
import 'package:yoon_wi/features/history/domain/entities/trip_history_entry.dart';
import 'package:yoon_wi/features/history/domain/usecases/add_to_history.dart';
import 'package:yoon_wi/features/history/domain/usecases/clear_history.dart';
import 'package:yoon_wi/features/history/domain/usecases/get_history.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';

/// Partagé par la recherche, la page Historique et les résultats
/// (enregistré comme singleton).
class HistoryCubit extends Cubit<LoadState<List<TripHistoryEntry>>> {
  HistoryCubit({
    required GetHistory getHistory,
    required AddToHistory addToHistory,
    required ClearHistory clearHistory,
    DateTime Function()? clock,
  })  : _get = getHistory,
        _add = addToHistory,
        _clear = clearHistory,
        _clock = clock ?? DateTime.now,
        super(const LoadState.loading());

  final GetHistory _get;
  final AddToHistory _add;
  final ClearHistory _clear;
  final DateTime Function() _clock;

  Future<void> load() async {
    emit(const LoadState.loading());
    _emit(await _get(const NoParams()));
  }

  Future<void> add({
    required Place from,
    required Place to,
    required int fare,
    required int minMinutes,
    required int maxMinutes,
  }) async {
    _emit(await _add(TripHistoryEntry(
      from: from,
      to: to,
      fare: fare,
      minMinutes: minMinutes,
      maxMinutes: maxMinutes,
      at: _clock(),
    )));
  }

  Future<void> clear() async => _emit(await _clear(const NoParams()));

  void _emit(Either<Failure, List<TripHistoryEntry>> result) {
    if (isClosed) return;
    result.fold(
          (failure) => emit(LoadState.failure(failure.message)),
          (entries) => emit(LoadState.success(entries)),
    );
  }
}