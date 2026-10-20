import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoon_wi/core/services/permission_service.dart';
import 'package:yoon_wi/core/usecases/usecase.dart';
import 'package:yoon_wi/features/onboarding/domain/usecases/mark_onboarding_seen.dart';
import 'package:yoon_wi/features/onboarding/presentation/bloc/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({
    required MarkOnboardingSeen markSeen,
    required PermissionService permissions,
  }) : _markSeen = markSeen,
       _permissions = permissions,
       super(const OnboardingState());

  final MarkOnboardingSeen _markSeen;
  final PermissionService _permissions;

  Future<void> finish({required bool askPermissions}) async {
    emit(const OnboardingState(status: OnboardingStatus.loading));
    if (askPermissions) {
      await _permissions.requestLocation();
      await _permissions.requestNotifications();
    }
    await _markSeen(const NoParams());
    emit(const OnboardingState(status: OnboardingStatus.done));
  }
}
