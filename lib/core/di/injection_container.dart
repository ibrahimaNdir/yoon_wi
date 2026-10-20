import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoon_wi/core/data/local_json_loader.dart';
import 'package:yoon_wi/core/services/permission_service.dart';
import 'package:yoon_wi/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:yoon_wi/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:yoon_wi/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:yoon_wi/features/onboarding/domain/usecases/get_onboarding_seen.dart';
import 'package:yoon_wi/features/onboarding/domain/usecases/mark_onboarding_seen.dart';
import 'package:yoon_wi/features/onboarding/presentation/bloc/onboarding_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);
  sl.registerLazySingleton<LocalJsonLoader>(() => LocalJsonLoader());
  sl.registerLazySingleton<PermissionService>(() => PermissionService());

  // Onboarding
  sl.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetOnboardingSeen(sl()));
  sl.registerLazySingleton(() => MarkOnboardingSeen(sl()));
  sl.registerFactory(() => OnboardingCubit(markSeen: sl(), permissions: sl()));
}
