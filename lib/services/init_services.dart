import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db_models/user_model.dart';
import '../models/chats_notifier.dart';
import '../models/loaded_settings.dart';
import '../repositories/local_db_repository.dart';
import '../repositories/shared_pref_repo.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../utils/constants.dart';

final initServicesProvider = Provider<InitServices>((ref) {
  return InitServices(ref: ref);
});
final socketProvider = Provider<io.Socket>((ref) {
  return io.io(baseUrl, <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });
});

class InitServices {
  Ref ref;
  InitServices({required this.ref});

  Future init() async {
    final sharedPref = ref.read(sharedPrefProvider);
    final localDbProv = ref.read(localDbRepositoryProvider);
    final chatsProv = ref.read(chatsProvider.notifier);
    await handlePermissions();

    await localDbProv.init();
    chatsProv.setAllChats(await localDbProv.getAllChats());

    ThemeMode themeMode = await sharedPref.getThemeMode();
    final user = await localDbProv.getLoggedInUser();
    ref.read(userProvider.notifier).state = user;
    //May add some other stuff later such as Token verification etc
    ref
        .read(loadedSettingsStateProvider.notifier)
        .update((state) => state.copyWith(themeMode: themeMode));

    final socket = ref.read(socketProvider);
    socket.connect();
    socket.onConnect((_) {
      print('connect');
      socket.emit('msg', 'test');
    });
  }

  handlePermissions() async {
    //Ask Permissions for storage and camera, contacts
    await [Permission.storage, Permission.camera, Permission.contacts]
        .request();
  }
}
