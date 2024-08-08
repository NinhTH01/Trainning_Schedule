import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/data/services/shared_preferences/shared_preferences_manager.dart';
import 'package:ts_basecode/providers/app_router_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final onboarding = await SharedPreferencesManager.getOnboarding();
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: MyApp(
          onboarding: onboarding,
        ),
      ),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  final bool onboarding;

  const MyApp({super.key, required this.onboarding});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppState();
}

class _AppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      builder: (context, child) {
        final data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child ?? Container(),
        );
      },
      debugShowCheckedModeBanner: true,
      routerConfig: ref.read(appRouterProvider).config(),
    );
  }
}
