import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoon_wi/features/guidance/domain/entities/guidance_progress.dart';
import 'package:yoon_wi/features/guidance/domain/entities/trip_summary.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/itinerary.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';

class GuidanceState extends Equatable {
  const GuidanceState({required this.progress, this.summary});

  final GuidanceProgress progress;

  /// Renseigné quand la dernière étape est terminée.
  final TripSummary? summary;

  bool get finished => summary != null;

  @override
  List<Object?> get props => [progress, summary];
}

class GuidanceCubit extends Cubit<GuidanceState> {
  GuidanceCubit({
    required Itinerary itinerary,
    required Place from,
    required Place to,
    DateTime Function()? clock,
  }) : _itinerary = itinerary,
       _from = from,
       _to = to,
       _clock = clock ?? DateTime.now,
       super(
         GuidanceState(progress: GuidanceProgress(steps: itinerary.steps)),
       ) {
    _startedAt = _clock();
  }

  final Itinerary _itinerary;
  final Place _from;
  final Place _to;
  final DateTime Function() _clock;
  late final DateTime _startedAt;

  void next() {
    if (state.finished) return;
    final progress = state.progress;

    if (!progress.isLast) {
      emit(GuidanceState(progress: progress.advance()));
      return;
    }

    final seconds = _clock().difference(_startedAt).inSeconds;
    emit(
      GuidanceState(
        progress: progress,
        summary: TripSummary(
          from: _from,
          to: _to,
          fare: _itinerary.fare,
          plannedMin: _itinerary.minMinutes,
          plannedMax: _itinerary.maxMinutes,
          actualMinutes: math.max(1, (seconds / 60).ceil()),
        ),
      ),
    );
  }

  void previous() {
    if (state.finished) return;
    emit(GuidanceState(progress: state.progress.back()));
  }
}
