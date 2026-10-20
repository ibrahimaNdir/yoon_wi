import 'package:dartz/dartz.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/core/usecases/usecase.dart';
import 'package:yoon_wi/features/networks/domain/entities/transport_type.dart';
import 'package:yoon_wi/features/networks/domain/repositories/network_repository.dart';

class GetTransportTypes extends UseCase<List<TransportType>, NoParams> {
  GetTransportTypes(this._repository);
  final NetworkRepository _repository;

  @override
  Future<Either<Failure, List<TransportType>>> call(NoParams params) =>
      _repository.getTransportTypes();
}
