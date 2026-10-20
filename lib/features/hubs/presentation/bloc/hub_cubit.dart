import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoon_wi/core/bloc/load_state.dart';
import 'package:yoon_wi/features/hubs/domain/entities/hub.dart';
import 'package:yoon_wi/features/hubs/domain/usecases/get_hub.dart';

class HubCubit extends Cubit<LoadState<Hub>> {
  HubCubit(this._getHub) : super(const LoadState.loading());
  final GetHub _getHub;

  Future<void> load(String id) async {
    emit(const LoadState.loading());
    final result = await _getHub(id);
    result.fold(
      (failure) => emit(LoadState.failure(failure.message)),
      (hub) => emit(LoadState.success(hub)),
    );
  }
}
