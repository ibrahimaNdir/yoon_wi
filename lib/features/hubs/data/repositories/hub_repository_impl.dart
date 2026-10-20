import 'package:dartz/dartz.dart';
import 'package:yoon_wi/core/error/exceptions.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/features/hubs/data/datasources/hub_local_datasource.dart';
import 'package:yoon_wi/features/hubs/domain/entities/hub.dart';
import 'package:yoon_wi/features/hubs/domain/repositories/hub_repository.dart';

class HubRepositoryImpl implements HubRepository {
  HubRepositoryImpl(this._local);
  final HubLocalDataSource _local;

  @override
  Future<Either<Failure, List<Hub>>> getHubs() async {
    try {
      return Right(await _local.getHubs());
    } on LocalException catch (e) {
      return Left(LocalFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Hub>> getHub(String id) async {
    final result = await getHubs();
    return result.fold<Either<Failure, Hub>>((failure) => Left(failure), (
      hubs,
    ) {
      for (final hub in hubs) {
        if (hub.id == id) return Right(hub);
      }
      return const Left<Failure, Hub>(NotFoundFailure('Hub introuvable.'));
    });
  }
}
