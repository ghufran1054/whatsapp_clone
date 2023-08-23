import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/db_models/message.dart';

import '../repositories/local_db_repository.dart';

//This class is used to manage the state of the messages of the current chat
final messagesProvider =
    StateNotifierProvider<MessagesNotifier, List<Message>>((ref) {
  return MessagesNotifier(ref);
});

class MessagesNotifier extends StateNotifier<List<Message>> {
  final Ref ref;
  MessagesNotifier(this.ref) : super([]);
  void setAllMessages(List<Message> messages) {
    state = messages;
  }

  Future fetchAndSetMessages(String? chatId) async {
    if (chatId == null) {
      ref.read(messagesProvider.notifier).setAllMessages([]);
      return;
    }
    final localDb = ref.read(localDbRepositoryProvider);
    final messages = await localDb.getMessagesForChat(chatId);
    ref.read(messagesProvider.notifier).setAllMessages(messages);
  }

  Future<int> addMessage(Message message, {int? chatId}) async {
    if (chatId != null) {
      message = message.copyWith(chatId: chatId.toString());
    }
    final localDb = ref.read(localDbRepositoryProvider);
    int id = await localDb.saveMessage(message);
    state = [message.copyWith(id: id), ...state];
    return id;
  }

  Future updateMessage(Message message) async {
    log('updating message id: ${message.id}');
    state = state.map((msg) {
      log('current id: ${msg.id}');
      if (msg.id == message.id) {
        log('updating message status: ${message.status}');
        return message;
      } else {
        return msg.copyWith();
      }
    }).toList();
    final localDb = ref.read(localDbRepositoryProvider);
    await localDb.saveMessage(message);
  }
}
