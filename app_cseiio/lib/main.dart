import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/config.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  await Environment.initEnvironment();

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,

      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('es', 'ES'), // Español
      ],

      locale: const Locale('es', 'ES'),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
    );
  }
}
