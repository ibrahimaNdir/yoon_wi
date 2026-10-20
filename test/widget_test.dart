import 'package:flutter_test/flutter_test.dart';
import 'package:yoon_wi/app.dart';

void main() {
  testWidgets('la barre du bas change de page', (tester) async {
    await tester.pumpWidget(const YoonWiApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('étape F7'), findsOneWidget);

    await tester.tap(find.text('Réseaux'));
    await tester.pumpAndSettle();
    expect(find.textContaining('étape F5'), findsOneWidget);

    await tester.tap(find.text('Favoris'));
    await tester.pumpAndSettle();
    expect(find.textContaining('étape F11'), findsOneWidget);

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.textContaining('étape F14'), findsOneWidget);
  });
}
