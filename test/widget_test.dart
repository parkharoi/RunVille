import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:run_ville/features/home/presentation/home_page.dart';
import 'package:run_ville/features/home/presentation/home_view_model.dart';

void main() {
  testWidgets('Home screen renders the idle running layout', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: HomePage())),
    );

    expect(find.text('Run Ville'), findsOneWidget);
    expect(find.text('시작'), findsOneWidget);
    expect(find.text('GPS를 켜고 달려보세요'), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.byIcon(Icons.stop_rounded), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
    expect(find.byIcon(Icons.music_note_rounded), findsOneWidget);
  });

  testWidgets('Run view model starts idle with no live route', (
    WidgetTester tester,
  ) async {
    final ProviderContainer container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: HomePage()),
      ),
    );

    expect(container.read(homeViewModelProvider).isPaused, isTrue);
    expect(container.read(homeViewModelProvider).distanceKm, 0);
    expect(container.read(homeViewModelProvider).routePoints, isEmpty);
  });
}
