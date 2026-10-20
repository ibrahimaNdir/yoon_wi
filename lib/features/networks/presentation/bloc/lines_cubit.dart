import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoon_wi/core/bloc/load_state.dart';
import 'package:yoon_wi/features/networks/domain/entities/transport_type.dart';
import 'package:yoon_wi/features/networks/domain/usecases/get_lines.dart';

class LinesCubit extends Cubit<LoadState<TransportType>> {
  LinesCubit(this._getLines) : super(const LoadState.loading());
  final GetLines _getLines;

  Future<void> load(String typeName) async {
    emit(const LoadState.loading());
    final result = await _getLines(typeName);
    result.fold(
      (failure) => emit(LoadState.failure(failure.message)),
      (type) => emit(LoadState.success(type)),
    );
  }
}
