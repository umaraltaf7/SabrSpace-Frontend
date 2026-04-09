import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sabr_space/core/theme/theme_bootstrap.dart';

/// Persists [ThemeMode] (light / dark / system) via [persistThemeMode].
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => initialThemeMode;

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await persistThemeMode(mode);
  }
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
