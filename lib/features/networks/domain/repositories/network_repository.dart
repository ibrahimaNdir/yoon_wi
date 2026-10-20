import 'package:dartz/dartz.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/features/networks/domain/entities/line.dart';
import 'package:yoon_wi/features/networks/domain/entities/transport_type.dart';

abstract class NetworkRepository {
  Future<Either<Failure, List<TransportType>>> getTransportTypes();
  Future<Either<Failure, TransportType>> getTransportType(String name);
  Future<Either<Failure, Line>> getLine(String typeName, String lineCode);
}
