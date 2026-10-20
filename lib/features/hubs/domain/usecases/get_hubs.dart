import 'package:dartz/dartz.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/core/usecases/usecase.dart';
import 'package:yoon_wi/features/hubs/domain/entities/hub.dart';
import 'package:yoon_wi/features/hubs/domain/repositories/hub_repository.dart';

class GetHubs extends UseCase<List<Hub>, NoParams> {
  GetHubs(this._repository);
  final HubRepository _repository;

  @override
  Future<Either<Failure, List<Hub>>> call(NoParams params) =>
      _repository.getHubs();
}
