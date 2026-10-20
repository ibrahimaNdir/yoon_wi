import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoon_wi/app.dart';
import 'package:yoon_wi/core/di/injection_container.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await sl.reset();
    await initDependencies();
  });

  testWidgets('la barre du bas change de page', (tester) async {
    await tester.pumpWidget(const YoonWiApp());
    await tester.pumpAndSettle();
    expect(find.text('Où allez-vous aujourd’hui ?'), findsOneWidget);

    await tester.tap(find.text('Réseaux'));
    await tester.pumpAndSettle();
    expect(find.text('Réseaux et tarifs'), findsOneWidget);

    await tester.tap(find.text('Favoris'));
    await tester.pumpAndSettle();
    expect(find.textContaining('étape F11'), findsOneWidget);

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.textContaining('étape F14'), findsOneWidget);
  });
}
