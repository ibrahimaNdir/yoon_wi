import 'package:dartz/dartz.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/core/usecases/usecase.dart';
import 'package:yoon_wi/features/onboarding/domain/repositories/onboarding_repository.dart';

class MarkOnboardingSeen extends UseCase<void, NoParams> {
  MarkOnboardingSeen(this._repository);
  final OnboardingRepository _repository;

  @override
  Future<Either<Failure, void>> call(NoParams params) => _repository.markSeen();
}
