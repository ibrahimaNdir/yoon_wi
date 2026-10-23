import 'package:dartz/dartz.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/features/history/domain/entities/trip_history_entry.dart';

/// Chaque modification renvoie l'historique à jour.
abstract class HistoryRepository {
  Future<Either<Failure, List<TripHistoryEntry>>> getHistory();
  Future<Either<Failure, List<TripHistoryEntry>>> add(TripHistoryEntry entry);
  Future<Either<Failure, List<TripHistoryEntry>>> clear();
}