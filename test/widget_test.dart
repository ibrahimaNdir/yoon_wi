import 'package:flutter_test/flutter_test.dart';
import 'package:yoon_wi/app.dart';

void main() {
  testWidgets('l’application démarre', (tester) async {
    await tester.pumpWidget(const YoonWiApp());
    expect(find.text('Yoon Wi'), findsWidgets);
  });
}
