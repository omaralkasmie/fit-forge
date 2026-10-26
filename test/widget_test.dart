import 'package:flutter_test/flutter_test.dart';
import 'package:fit_forge/main.dart';

void main() {
  testWidgets('FitForge app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FitForgeApp());

    expect(find.text('FitForge'), findsOneWidget);
  });
}