import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/core/usecases/usecase.dart';
import 'package:yoon_wi/features/networks/domain/entities/line.dart';
import 'package:yoon_wi/features/networks/domain/repositories/network_repository.dart';

class StopsParams extends Equatable {
  const StopsParams({required this.typeName, required this.lineCode});
  final String typeName;
  final String lineCode;

  @override
  List<Object> get props => [typeName, lineCode];
}

/// Renvoie une ligne avec uniquement ses arrêts.
class GetStops extends UseCase<Line, StopsParams> {
  GetStops(this._repository);
  final NetworkRepository _repository;

  @override
  Future<Either<Failure, Line>> call(StopsParams params) =>
      _repository.getLine(params.typeName, params.lineCode);
}
