import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../db_models/chat.dart';
import '../db_models/chat_user.dart';
import '../db_models/user_model.dart';
import '../db_models/message.dart';

final localDbRepositoryProvider = Provider((ref) => LocalDbRepository());

class LocalDbRepository {
  Isar? _isar;

  Isar get isarInstance => _isar!;
  void dispose() {
    _isar!.close();
  }

  Future<int> saveChat(Chat chat) async {
    return await _isar!.writeTxn(() async {
      return await _isar!.chats.put(chat);
    });
  }

  Future<Chat?> getChat(int id) async {
    return await _isar!.chats.get(id);
  }

  Future<Chat?> getChatbymId(String mId) async {
    return await _isar!.chats.where().mIdEqualTo(mId).findFirst();
  }

  Future<List<Message>> getMessagesForChat(String chatmId) async {
    return await _isar!.messages
        .where(sort: Sort.desc)
        .chatIdEqualToAnyCreatedAt(chatmId)
        .findAll();
  }

  List<Message> getQueuedMessagesSync() {
    return _isar!.messages
        .filter()
        .statusEqualTo("queued", caseSensitive: false)
        .findAllSync();
  }

  Future<List<Chat>> getQueuedChats() async {
    return await _isar!.chats.filter().mIdIsNull().findAll();
  }

  //This Function Will update the chatId of all the messages of a chat (Used For the case where the Chat is created offline and then synced with the server)
  Future updateMessagesChatId(int chatId, String chatmId) async {
    await _isar!.writeTxn(() async {
      final messages = await _isar!.messages
          .where()
          .chatIdEqualToAnyCreatedAt(chatId.toString())
          .findAll();
      for (Message message in messages) {
        message = message.copyWith(chatId: chatmId);
        await _isar!.messages.put(message);
      }
    });
  }

  ChatUser? getUserSync(String id) {
    return _isar!.chatUsers.filter().mIdEqualTo(id).findFirstSync();
  }

  List<Message> getMessagesForChatSync(String chatId) {
    return _isar!.messages
        .where(sort: Sort.desc)
        .chatIdEqualToAnyCreatedAt(chatId)
        .findAllSync();
  }

  Future<int> saveMessage(Message message) async {
    return await _isar!.writeTxn(() async {
      return await _isar!.messages.put(message);
    });
  }

  updateIsar() async {
    //Write what you want to update here
    final allChats = await _isar!.chats.where().findAll();
    _isar!.writeTxn(() async {
      await _isar!.chats.putAll(allChats);
    });
  }

  Future<UserModel?> getLoggedInUser() async {
    return await _isar!.userModels.where().findFirst();
  }

  Future<void> saveLoggedInUser(UserModel user) async {
    await _isar!.writeTxn(() async {
      await _isar!.userModels.put(user);
    });
  }

  Future<List<ChatUser>> getAllChatUsers({bool getOnlySaved = false}) async {
    if (getOnlySaved) {
      return await _isar!.chatUsers.filter().savedNameIsNotNull().findAll();
    }
    return await _isar!.chatUsers.where().findAll();
  }

  Future saveChatUsers(List<ChatUser> users) async {
    if (users.isEmpty) return;
    await _isar!.writeTxn(() async {
      await _isar!.chatUsers.putAll(users);
    });
  }

  init() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [ChatSchema, UserModelSchema, ChatUserSchema, MessageSchema],
      directory: dir.path,
    );
  }

  Future<List<Chat>> getAllChats() async {
    return await _isar!.chats.where().findAll();
  }
}
