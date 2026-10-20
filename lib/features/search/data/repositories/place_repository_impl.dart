import 'package:dartz/dartz.dart';
import 'package:yoon_wi/core/error/exceptions.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/features/search/data/datasources/place_local_datasource.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';
import 'package:yoon_wi/features/search/domain/repositories/place_repository.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  PlaceRepositoryImpl(this._local);
  final PlaceLocalDataSource _local;

  @override
  Future<Either<Failure, List<Place>>> getPlaces() async {
    try {
      return Right(await _local.getPlaces());
    } on LocalException catch (e) {
      return Left(LocalFailure(e.message));
    }
  }
}
