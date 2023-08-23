import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/db_models/chat.dart';

import '../repositories/local_db_repository.dart';

final chatsProvider = StateNotifierProvider<ChatsNotifier, List<Chat>>((ref) {
  return ChatsNotifier(ref);
});

class ChatsNotifier extends StateNotifier<List<Chat>> {
  ChatsNotifier(this.ref) : super([]);
  final Ref ref;
  void setAllChats(List<Chat> chats) {
    state = chats;
  }

  Future<int> addChat(Chat chat) async {
    final localDb = ref.read(localDbRepositoryProvider);
    int id = await localDb.saveChat(chat);
    state = [...state, chat.copyWith(id: id)];
    return id;
  }

  Future updateChat(Chat chat) async {
    state = [
      for (final c in state)
        if (c.id == chat.id) chat else c
    ];
    final localDb = ref.read(localDbRepositoryProvider);
    await localDb.saveChat(chat);
  }
}
