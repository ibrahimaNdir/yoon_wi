import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoon_wi/core/bloc/load_state.dart';
import 'package:yoon_wi/core/usecases/usecase.dart';
import 'package:yoon_wi/features/networks/domain/entities/transport_type.dart';
import 'package:yoon_wi/features/networks/domain/usecases/get_transport_types.dart';

class TypesCubit extends Cubit<LoadState<List<TransportType>>> {
  TypesCubit(this._getTypes) : super(const LoadState.loading());
  final GetTransportTypes _getTypes;

  Future<void> load() async {
    emit(const LoadState.loading());
    final result = await _getTypes(const NoParams());
    result.fold(
      (failure) => emit(LoadState.failure(failure.message)),
      (types) => emit(LoadState.success(types)),
    );
  }
}
