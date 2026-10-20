import 'package:dartz/dartz.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/features/hubs/domain/entities/hub.dart';

abstract class HubRepository {
  Future<Either<Failure, List<Hub>>> getHubs();
  Future<Either<Failure, Hub>> getHub(String id);
}
