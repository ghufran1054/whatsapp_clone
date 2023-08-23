import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/db_models/user_model.dart';

import '../db_models/chat.dart';
import '../db_models/chat_user.dart';
import 'chats_provider.dart';

final selectedChatUserData = StateProvider<ChatUser?>((ref) {
  return null;
});
final selectedChatProvider = StateProvider<Chat?>((ref) {
  return null;
});
final chatProvider = StateProvider<Chat?>(((ref) {
  final chats = ref.watch(chatsProvider);
  final userData = ref.watch(selectedChatUserData);
  Chat? chat = ref.watch(selectedChatProvider);

  if (chat != null) {
    return chat;
  }
  if (userData == null) {
    return null;
  }
  try {
    chat = chats.firstWhere((Chat chat) => chat.chatUserId == userData.mId);
  } on StateError {
    chat = null;
  }
  chat ??= Chat(
    chatUserId: userData.mId,
    isGroup: false,
    unreadCount: 0,
    members: [userData.mId!, ref.read(userProvider)!.mId!],
  );
  return chat;
}));
