import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db_models/user_model.dart';
import '../models/loaded_settings.dart';
import '../providers/chats_provider.dart';
import '../repositories/local_db_repository.dart';
import '../repositories/shared_pref_repo.dart';
import 'package:permission_handler/permission_handler.dart';

final initServicesProvider = Provider<InitServices>((ref) {
  return InitServices(ref: ref);
});

class InitServices {
  Ref ref;
  InitServices({required this.ref});
  Future _loadChats() async {
    final localDbProv = ref.read(localDbRepositoryProvider);
    final chatsProv = ref.read(chatsProvider.notifier);
    chatsProv.setAllChats(await localDbProv.getAllChats());
  }

  Future _loadUserSettings() async {
    final sharedPref = ref.read(sharedPrefProvider);
    final localDbProv = ref.read(localDbRepositoryProvider);
    ThemeMode themeMode = await sharedPref.getThemeMode();
    final user = await localDbProv.getLoggedInUser();
    ref.read(userProvider.notifier).state = user;
    //May add some other stuff later such as Token verification etc
    ref
        .read(loadedSettingsStateProvider.notifier)
        .update((state) => state.copyWith(themeMode: themeMode));
    log('user: ${user?.phone}');
  }

  Future init() async {
    final localDbProv = ref.read(localDbRepositoryProvider);
    await _handlePermissions();
    await localDbProv.init();
    await _loadChats();
    await _loadUserSettings();
  }

  Future _handlePermissions() async {
    //Ask Permissions for storage and camera, contacts
    await [Permission.storage, Permission.camera, Permission.contacts]
        .request();
  }
}
