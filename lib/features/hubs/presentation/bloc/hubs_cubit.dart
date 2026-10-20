import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoon_wi/core/bloc/load_state.dart';
import 'package:yoon_wi/core/usecases/usecase.dart';
import 'package:yoon_wi/features/hubs/domain/entities/hub.dart';
import 'package:yoon_wi/features/hubs/domain/usecases/get_hubs.dart';

class HubsCubit extends Cubit<LoadState<List<Hub>>> {
  HubsCubit(this._getHubs) : super(const LoadState.loading());
  final GetHubs _getHubs;

  Future<void> load() async {
    emit(const LoadState.loading());
    final result = await _getHubs(const NoParams());
    result.fold(
      (failure) => emit(LoadState.failure(failure.message)),
      (hubs) => emit(LoadState.success(hubs)),
    );
  }
}
