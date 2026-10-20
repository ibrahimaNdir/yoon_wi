import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoon_wi/core/bloc/load_state.dart';
import 'package:yoon_wi/features/networks/domain/entities/line.dart';
import 'package:yoon_wi/features/networks/domain/usecases/get_stops.dart';

class StopsCubit extends Cubit<LoadState<Line>> {
  StopsCubit(this._getStops) : super(const LoadState.loading());
  final GetStops _getStops;

  Future<void> load(String typeName, String lineCode) async {
    emit(const LoadState.loading());
    final result = await _getStops(
      StopsParams(typeName: typeName, lineCode: lineCode),
    );
    result.fold(
      (failure) => emit(LoadState.failure(failure.message)),
      (line) => emit(LoadState.success(line)),
    );
  }
}
