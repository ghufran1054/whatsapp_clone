import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../db_models/chat.dart';
import '../db_models/chat_user.dart';
import '../db_models/user_model.dart';

final localDbRepositoryProvider = Provider((ref) => LocalDbRepository());

class LocalDbRepository {
  Isar? isar;

  void dispose() {
    isar!.close();
  }

  Future<UserModel?> getLoggedInUser() async {
    return await isar!.userModels.where().findFirst();
  }

  Future<void> saveLoggedInUser(UserModel user) async {
    await isar!.writeTxn(() async {
      await isar!.userModels.put(user);
    });
  }

  init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [ChatSchema, UserModelSchema, ChatUserSchema],
      directory: dir.path,
    );
  }

  Future<List<Chat>> getAllChats() async {
    return await isar!.chats.where().findAll();
  }
}
