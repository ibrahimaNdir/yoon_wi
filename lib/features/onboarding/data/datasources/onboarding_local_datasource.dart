import 'package:shared_preferences/shared_preferences.dart';

abstract class OnboardingLocalDataSource {
  Future<bool> isSeen();
  Future<void> markSeen();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  OnboardingLocalDataSourceImpl(this._prefs);
  final SharedPreferences _prefs;

  static const _key = 'onboarding_seen';

  @override
  Future<bool> isSeen() async => _prefs.getBool(_key) ?? false;

  @override
  Future<void> markSeen() async {
    await _prefs.setBool(_key, true);
  }
}
