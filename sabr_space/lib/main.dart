import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:sabr_space/core/providers/theme_mode_provider.dart';
import 'package:sabr_space/core/router/app_router.dart';
import 'package:sabr_space/core/theme/app_theme.dart';
import 'package:sabr_space/core/theme/theme_bootstrap.dart';
import 'package:sabr_space/features/journal/data/models/journal_entry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await bootstrapThemeMode();

  // Initialize Hive for local storage
  await Hive.initFlutter();
  Hive.registerAdapter(JournalEntryAdapter());
  Hive.registerAdapter(JournalMoodAdapter());

  runApp(const ProviderScope(child: SabrSpaceApp()));
}

class SabrSpaceApp extends ConsumerWidget {
  const SabrSpaceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'SabrSpace',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      themeAnimationDuration: const Duration(milliseconds: 280),
      themeAnimationCurve: Curves.easeInOutCubic,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
