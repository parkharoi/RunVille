import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_ville/app/app.dart';
import 'package:run_ville/core/config/env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.initialize();

  runApp(const ProviderScope(child: RunVilleApp()));
}
