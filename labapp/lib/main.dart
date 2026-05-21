import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_environment.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const environment = String.fromEnvironment('ENV', defaultValue: 'dev');
  AppEnvironment.configure(environment == 'prod' ? Flavor.prod : Flavor.dev);
  runApp(const ProviderScope(child: LabApp()));
}

class LabApp extends ConsumerWidget {
  const LabApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'LabApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: router,
    );
  }
}
