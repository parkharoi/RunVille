import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:run_ville/core/config/env.dart';

final healthCheckProvider = FutureProvider.autoDispose<String>((ref) async {
  try {
    await Supabase.instance.client.from('runs').select('id').limit(1);
    return 'ok';
  } on PostgrestException catch (error) {
    return 'query-error-${error.code ?? 'unknown'}';
  } catch (_) {
    return 'network-error';
  }
});

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<String> healthState = ref.watch(healthCheckProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Run Ville')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Flavor: ${Env.flavor}'),
            const SizedBox(height: 24),
            const Text('Supabase health check'),
            const SizedBox(height: 8),
            healthState.when(
              data: (value) => Text('Status: $value'),
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) => Text('Status: error - $error'),
            ),
          ],
        ),
      ),
    );
  }
}
