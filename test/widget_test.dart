import 'package:flutter_test/flutter_test.dart';
import 'package:lunaverse/main.dart';

void main() {
  testWidgets('shows the LunaVerse authentication screen', (tester) async {
    await tester.pumpWidget(const LunaVerseApp());
    await tester.pumpAndSettle();
    expect(find.text('Welcome back!'), findsOneWidget);
    expect(find.text('Nova'), findsOneWidget);
  });
}
