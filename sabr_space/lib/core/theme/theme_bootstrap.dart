import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kThemeModeKey = 'theme_mode';

ThemeMode? _bootstrappedThemeMode;

/// Loads saved [ThemeMode] before [runApp] to avoid a one-frame flash.
Future<void> bootstrapThemeMode() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(_kThemeModeKey);
  _bootstrappedThemeMode = ThemeMode.values.asNameMap()[raw];
}

/// Effective mode before first [ThemeModeNotifier] update (after [bootstrapThemeMode]).
ThemeMode get initialThemeMode => _bootstrappedThemeMode ?? ThemeMode.dark;

Future<void> persistThemeMode(ThemeMode mode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_kThemeModeKey, mode.name);
}
