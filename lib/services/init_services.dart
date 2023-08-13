import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db_models/user_model.dart';
import '../models/loaded_settings.dart';
import '../repositories/local_db_repository.dart';
import '../repositories/shared_pref_repo.dart';

final initServicesProvider = Provider<InitServices>((ref) {
  return InitServices(ref: ref);
});

class InitServices {
  Ref ref;
  InitServices({required this.ref});

  Future init() async {
    final sharedPref = ref.read(sharedPrefProvider);
    final localDbProv = ref.read(localDbRepositoryProvider);
    await localDbProv.init();
    ThemeMode themeMode = await sharedPref.getThemeMode();
    final user = await localDbProv.getLoggedInUser();
    ref.read(userProvider.notifier).state = user;
    //May add some other stuff later such as Token verification etc
    ref
        .read(loadedSettingsStateProvider.notifier)
        .update((state) => state.copyWith(themeMode: themeMode));
  }
}
