import 'package:flutter/material.dart';

import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';
import 'dependencies.dart';

/// Widget racine de l'application Orléans Connect.
class OrleansConnectApp extends StatelessWidget {
  const OrleansConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppDependencies(
      child: MaterialApp.router(
        title: 'Orléans Connect',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
