import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/db_models/chat.dart';

final chatsProvider = StateNotifierProvider<ChatsNotifier, List<Chat>>((ref) {
  return ChatsNotifier();
});

class ChatsNotifier extends StateNotifier<List<Chat>> {
  ChatsNotifier() : super([]);
  void setAllChats(List<Chat> chats) {
    state = chats;
  }

  void addChat(Chat chat) {
    state = [...state, chat];
  }
}
