import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:run_ville/app/app.dart';
import 'package:run_ville/features/home/presentation/home_page.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [healthCheckProvider.overrideWith((ref) async => 'ok')],
        child: const RunVilleApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Run Ville'), findsOneWidget);
    expect(find.textContaining('Flavor:'), findsOneWidget);
    expect(find.textContaining('Status: ok'), findsOneWidget);
  });
}
