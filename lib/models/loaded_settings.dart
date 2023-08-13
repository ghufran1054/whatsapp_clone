import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loadedSettingsStateProvider = StateProvider<LoadedSettings>((ref) {
  return LoadedSettings();
});

class LoadedSettings {
  final ThemeMode? _themeMode;
  LoadedSettings({
    ThemeMode? themeMode,
  }) : _themeMode = themeMode;

  get themeMode => _themeMode;

  //copy with method
  LoadedSettings copyWith({ThemeMode? themeMode}) {
    return LoadedSettings(
      themeMode: themeMode ?? _themeMode,
    );
  }
}
