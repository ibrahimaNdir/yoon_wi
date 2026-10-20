import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/core/services/permission_service.dart';
import 'package:yoon_wi/core/usecases/usecase.dart';
import 'package:yoon_wi/features/onboarding/domain/usecases/mark_onboarding_seen.dart';
import 'package:yoon_wi/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:yoon_wi/features/onboarding/presentation/bloc/onboarding_state.dart';

class MockMarkSeen extends Mock implements MarkOnboardingSeen {}

class MockPermissions extends Mock implements PermissionService {}

void main() {
  late MockMarkSeen markSeen;
  late MockPermissions permissions;

  setUpAll(() => registerFallbackValue(const NoParams()));

  setUp(() {
    markSeen = MockMarkSeen();
    permissions = MockPermissions();
    when(
      () => markSeen(any()),
    ).thenAnswer((_) async => const Right<Failure, void>(null));
    when(() => permissions.requestLocation()).thenAnswer((_) async => true);
    when(
      () => permissions.requestNotifications(),
    ).thenAnswer((_) async => true);
  });

  blocTest<OnboardingCubit, OnboardingState>(
    'Continuer : demande les permissions puis termine',
    build: () => OnboardingCubit(markSeen: markSeen, permissions: permissions),
    act: (cubit) => cubit.finish(askPermissions: true),
    expect:
        () => const [
          OnboardingState(status: OnboardingStatus.loading),
          OnboardingState(status: OnboardingStatus.done),
        ],
    verify: (_) {
      verify(() => permissions.requestLocation()).called(1);
      verify(() => markSeen(any())).called(1);
    },
  );

  blocTest<OnboardingCubit, OnboardingState>(
    'Plus tard : ne demande aucune permission',
    build: () => OnboardingCubit(markSeen: markSeen, permissions: permissions),
    act: (cubit) => cubit.finish(askPermissions: false),
    expect:
        () => const [
          OnboardingState(status: OnboardingStatus.loading),
          OnboardingState(status: OnboardingStatus.done),
        ],
    verify: (_) {
      verifyNever(() => permissions.requestLocation());
      verify(() => markSeen(any())).called(1);
    },
  );
}
