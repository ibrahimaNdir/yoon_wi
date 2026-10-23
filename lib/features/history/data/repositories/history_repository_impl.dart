import 'package:dartz/dartz.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/features/history/data/datasources/history_local_datasource.dart';
import 'package:yoon_wi/features/history/domain/entities/trip_history_entry.dart';
import 'package:yoon_wi/features/history/domain/repositories/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  HistoryRepositoryImpl(this._local);
  final HistoryLocalDataSource _local;

  static const maxEntries = 50;

  @override
  Future<Either<Failure, List<TripHistoryEntry>>> getHistory() async {
    try {
      return Right(await _local.read());
    } catch (_) {
      return const Left(LocalFailure('Historique indisponible.'));
    }
  }

  @override
  Future<Either<Failure, List<TripHistoryEntry>>> add(
    TripHistoryEntry entry,
  ) async {
    try {
      final current = await _local.read();
      final updated =
          [
            entry,
            ...current.where((e) => e.id != entry.id),
          ].take(maxEntries).toList();
      await _local.write(updated);
      return Right(updated);
    } catch (_) {
      return const Left(LocalFailure('Enregistrement impossible.'));
    }
  }

  @override
  Future<Either<Failure, List<TripHistoryEntry>>> clear() async {
    try {
      await _local.write(const []);
      return const Right([]);
    } catch (_) {
      return const Left(LocalFailure('Suppression impossible.'));
    }
  }
}
