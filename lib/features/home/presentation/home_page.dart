import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_ville/core/config/env.dart';
import 'package:run_ville/core/network/api_client.dart';

final Provider<Dio> dioProvider = Provider<Dio>((ref) {
  return buildDioClient();
});

final Provider<ApiClient> apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(dioProvider));
});

final healthCheckProvider = FutureProvider.autoDispose<String>((ref) async {
  final ApiClient apiClient = ref.watch(apiClientProvider);
  return apiClient.healthCheck();
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
            const SizedBox(height: 8),
            Text('API Base URL: ${Env.apiBaseUrl}'),
            const SizedBox(height: 24),
            const Text('Backend health check'),
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
