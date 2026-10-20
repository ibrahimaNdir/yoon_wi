import 'package:dartz/dartz.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/core/usecases/usecase.dart';
import 'package:yoon_wi/features/hubs/domain/entities/hub.dart';
import 'package:yoon_wi/features/hubs/domain/repositories/hub_repository.dart';

class GetHub extends UseCase<Hub, String> {
  GetHub(this._repository);
  final HubRepository _repository;

  @override
  Future<Either<Failure, Hub>> call(String id) => _repository.getHub(id);
}
