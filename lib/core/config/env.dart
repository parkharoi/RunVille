import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final class Env {
  Env._();

  static const String _flavorKey = 'FLAVOR';
  static const String _supabaseUrlKey = 'SUPABASE_URL';
  static const String _supabaseAnonKeyKey = 'SUPABASE_ANON_KEY';
  static const String _vworldApiKeyKey = 'VWORLD_API_KEY';

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

  static String get supabaseUrl => _safeRead(_supabaseUrlKey, fallback: '');

  static String get supabaseAnonKey =>
      _safeRead(_supabaseAnonKeyKey, fallback: '');

  static String get vworldApiKey => _safeRead(_vworldApiKeyKey, fallback: '');

  static bool get hasVworldApiKey => vworldApiKey.isNotEmpty;

  static String get mapTileUrlTemplate {
    if (hasVworldApiKey) {
      return 'https://api.vworld.kr/req/wmts/1.0.0/$vworldApiKey/Base/{z}/{y}/{x}.png';
    }
    return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  }

  static String get mapUserAgentPackageName => 'com.runville.app';

  static String _safeRead(String key, {required String fallback}) {
    try {
      return dotenv.maybeGet(key) ?? fallback;
    } catch (_) {
      return fallback;
    }
  }
}
