import 'package:dartz/dartz.dart';
import 'package:yoon_wi/core/error/exceptions.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/features/networks/data/datasources/network_local_datasource.dart';
import 'package:yoon_wi/features/networks/domain/entities/line.dart';
import 'package:yoon_wi/features/networks/domain/entities/transport_type.dart';
import 'package:yoon_wi/features/networks/domain/repositories/network_repository.dart';

class NetworkRepositoryImpl implements NetworkRepository {
  NetworkRepositoryImpl(this._local);
  final NetworkLocalDataSource _local;

  @override
  Future<Either<Failure, List<TransportType>>> getTransportTypes() async {
    try {
      return Right(await _local.getNetworks());
    } on LocalException catch (e) {
      return Left(LocalFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, TransportType>> getTransportType(String name) async {
    final result = await getTransportTypes();
    return result.fold<Either<Failure, TransportType>>(
      (failure) => Left(failure),
      (types) {
        for (final type in types) {
          if (type.name == name) return Right(type);
        }
        return const Left<Failure, TransportType>(
          NotFoundFailure('Type de transport introuvable.'),
        );
      },
    );
  }

  @override
  Future<Either<Failure, Line>> getLine(
    String typeName,
    String lineCode,
  ) async {
    final result = await getTransportType(typeName);
    return result.fold<Either<Failure, Line>>((failure) => Left(failure), (
      type,
    ) {
      for (final line in type.lines) {
        if (line.code == lineCode) return Right(line);
      }
      return const Left<Failure, Line>(NotFoundFailure('Ligne introuvable.'));
    });
  }
}
