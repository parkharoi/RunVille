import 'package:go_router/go_router.dart';
import 'package:run_ville/features/home/presentation/home_page.dart';

final class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
    ],
  );
}
