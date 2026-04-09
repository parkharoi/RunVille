import 'package:flutter/material.dart';
import 'package:run_ville/app/router/app_router.dart';
import 'package:run_ville/app/theme/app_theme.dart';

class RunVilleApp extends StatelessWidget {
  const RunVilleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Run Ville',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
    );
  }
}
