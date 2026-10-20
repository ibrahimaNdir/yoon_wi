import 'package:dartz/dartz.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:yoon_wi/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(this._local);
  final OnboardingLocalDataSource _local;

  @override
  Future<Either<Failure, bool>> isSeen() async {
    try {
      return Right(await _local.isSeen());
    } catch (_) {
      return const Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, void>> markSeen() async {
    try {
      await _local.markSeen();
      return const Right(null);
    } catch (_) {
      return const Left(LocalFailure());
    }
  }
}
