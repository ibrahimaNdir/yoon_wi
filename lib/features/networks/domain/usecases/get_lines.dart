import 'package:dartz/dartz.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/core/usecases/usecase.dart';
import 'package:yoon_wi/features/networks/domain/entities/transport_type.dart';
import 'package:yoon_wi/features/networks/domain/repositories/network_repository.dart';

/// Renvoie un type de transport avec uniquement ses lignes.
class GetLines extends UseCase<TransportType, String> {
  GetLines(this._repository);
  final NetworkRepository _repository;

  @override
  Future<Either<Failure, TransportType>> call(String typeName) =>
      _repository.getTransportType(typeName);
}
