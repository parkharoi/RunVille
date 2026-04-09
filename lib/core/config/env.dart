import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final class Env {
  Env._();

  static const String _flavorKey = 'FLAVOR';
  static const String _apiBaseUrlKey = 'API_BASE_URL';

  static Future<void> initialize() async {
    const String flavor = String.fromEnvironment(
      _flavorKey,
      defaultValue: 'dev',
    );
    final String filename =
        flavor == 'prod' ? 'assets/env/.env.prod' : 'assets/env/.env.dev';

    try {
      await dotenv.load(fileName: filename);
    } catch (_) {
      if (kDebugMode) {
        debugPrint('Env file not found: $filename. Fallback to defaults.');
      }
    }
  }

  static String get flavor =>
      const String.fromEnvironment(_flavorKey, defaultValue: 'dev');

  static String get apiBaseUrl => _safeRead(
    _apiBaseUrlKey,
    fallback: 'https://jsonplaceholder.typicode.com',
  );

  static String _safeRead(String key, {required String fallback}) {
    try {
      return dotenv.maybeGet(key) ?? fallback;
    } catch (_) {
      return fallback;
    }
  }
}
