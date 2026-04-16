import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:run_ville/app/app.dart';
import 'package:run_ville/core/config/env.dart';

// main.dart의 방향성
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Env.initialize();

  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);

  runApp(const ProviderScope(child: RunVilleApp()));
}
