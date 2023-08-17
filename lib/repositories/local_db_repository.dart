import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../db_models/chat.dart';
import '../db_models/chat_user.dart';
import '../db_models/user_model.dart';
import '../db_models/message.dart';

final localDbRepositoryProvider = Provider((ref) => LocalDbRepository());

class LocalDbRepository {
  Isar? isar;

  void dispose() {
    isar!.close();
  }

  updateIsar() async {
    //Write what you want to update here
    final allChats = await isar!.chats.where().findAll();
    isar!.writeTxn(() async {
      await isar!.chats.putAll(allChats);
    });
  }

  Future<UserModel?> getLoggedInUser() async {
    return await isar!.userModels.where().findFirst();
  }

  Future<void> saveLoggedInUser(UserModel user) async {
    await isar!.writeTxn(() async {
      await isar!.userModels.put(user);
    });
  }

  Future<List<ChatUser>> getAllChatUsers({bool getOnlySaved = false}) async {
    if (getOnlySaved) {
      return await isar!.chatUsers.filter().savedNameIsNotNull().findAll();
    }
    return await isar!.chatUsers.where().findAll();
  }

  Future saveChatUsers(List<ChatUser> users) async {
    if (users.isEmpty) return;
    await isar!.writeTxn(() async {
      await isar!.chatUsers.putAll(users);
    });
  }

  init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [ChatSchema, UserModelSchema, ChatUserSchema, MessageSchema],
      directory: dir.path,
    );
  }

  Future<List<Chat>> getAllChats() async {
    return await isar!.chats.where().findAll();
  }
}
