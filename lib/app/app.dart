import 'package:flutter/material.dart';

import 'router.dart';
import '../core/theme/app_theme.dart';

class DevShowApp extends StatelessWidget {
  const DevShowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DevShow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
