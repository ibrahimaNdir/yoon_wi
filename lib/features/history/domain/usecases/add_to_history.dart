import 'package:dartz/dartz.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/core/usecases/usecase.dart';
import 'package:yoon_wi/features/history/domain/entities/trip_history_entry.dart';
import 'package:yoon_wi/features/history/domain/repositories/history_repository.dart';

class AddToHistory extends UseCase<List<TripHistoryEntry>, TripHistoryEntry> {
  AddToHistory(this._repository);
  final HistoryRepository _repository;

  @override
  Future<Either<Failure, List<TripHistoryEntry>>> call(
    TripHistoryEntry entry,
  ) => _repository.add(entry);
}
