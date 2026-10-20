import 'package:flutter/material.dart';
import 'package:yoon_wi/app.dart';
import 'package:yoon_wi/core/di/injection_container.dart';
import 'package:yoon_wi/core/usecases/usecase.dart';
import 'package:yoon_wi/features/onboarding/domain/usecases/get_onboarding_seen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  final seen = await sl<GetOnboardingSeen>().call(const NoParams());
  final showOnboarding = seen.fold((_) => true, (value) => !value);

  runApp(YoonWiApp(showOnboarding: showOnboarding));
}
