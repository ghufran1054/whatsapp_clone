import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefProvider =
    Provider.autoDispose<SharedPreferencesRepository>((ref) {
  return SharedPreferencesRepository();
});

class SharedPreferencesRepository {
  SharedPreferences? sharedPref;

  Future<ThemeMode> getThemeMode() async {
    sharedPref = sharedPref ?? await SharedPreferences.getInstance();
    //Theme Mode can be light dark system
    String? themeMode = sharedPref?.getString('themeMode');
    if (themeMode == 'light') {
      return ThemeMode.light;
    } else if (themeMode == 'dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  Future setThemeMode(ThemeMode themeMode) async {
    sharedPref = sharedPref ?? await SharedPreferences.getInstance();
    if (themeMode == ThemeMode.light) {
      sharedPref?.setString('themeMode', 'light');
    } else if (themeMode == ThemeMode.dark) {
      sharedPref?.setString('themeMode', 'dark');
    } else {
      sharedPref?.setString('themeMode', 'system');
    }
  }

  Future<String> getToken() async {
    sharedPref = sharedPref ?? await SharedPreferences.getInstance();
    String? token = sharedPref?.getString('token');
    return token ?? '';
  }

  Future setToken(String token) async {
    sharedPref = sharedPref ?? await SharedPreferences.getInstance();
    sharedPref?.setString('token', token);
  }
}
