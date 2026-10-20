import 'package:dartz/dartz.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';

abstract class PlaceRepository {
  Future<Either<Failure, List<Place>>> getPlaces();
}
