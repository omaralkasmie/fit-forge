import 'package:flutter_test/flutter_test.dart';
import 'package:fit_forge/main.dart';
import 'package:fit_forge/data/local/app_database.dart';
import 'package:drift/native.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  testWidgets('FitForge app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(FitForgeApp(database: database));

    await tester.pumpAndSettle();

    expect(find.text('FitForge'), findsOneWidget);
  });
}
