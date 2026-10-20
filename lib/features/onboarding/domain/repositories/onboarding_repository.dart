import 'package:dartz/dartz.dart';
import 'package:yoon_wi/core/error/failures.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, bool>> isSeen();
  Future<Either<Failure, void>> markSeen();
}
