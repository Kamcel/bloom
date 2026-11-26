import 'package:bloom/core/router/app_router.dart'; // adjust if createRouter is in a different file
import 'package:bloom/core/theme/app_responsiveness.dart';
import 'package:bloom/core/theme/app_theme.dart';
import 'package:bloom/core/theme/theme_provider.dart';
import 'package:bloom/core/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: 'https://paliofaeluzccqhmfxva.supabase.co',
    publishableKey: 'sb_publishable_73dvBtOYrYJrv8dZUDHWuQ_l0krkwj0',
  );

  final router = createRouter();

  runApp(ProviderScope(child: BloomApp(router: router)));
}

class BloomApp extends ConsumerWidget {
  const BloomApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider).value ?? const ThemeState();

    return MaterialApp.router(
      title: 'Bloom',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeState.themeMode,
      routerConfig: router,
      builder: (context, child) => AppResponsiveness.wrap(
        context,
        child,
        userTextScale: themeState.textScale,
      ),
    );
  }
}
