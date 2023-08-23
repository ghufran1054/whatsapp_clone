import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/services/api_services.dart';
import 'package:whatsapp_clone/utils/constants.dart';
import 'package:contacts_service/contacts_service.dart';
import '../db_models/chat_user.dart';
import '../repositories/local_db_repository.dart';
import '../utils/util_functions.dart';

final contactsProvider = FutureProvider<List<ChatUser>>((ref) async {
  final apiProv = ref.read(apiServiceProvider);
  final localDb = ref.read(localDbRepositoryProvider);
  final chatUsers = await localDb.getAllChatUsers(getOnlySaved: true);

  //Checking if a valid Phone number
  final contacts = (await ContactsService.getContacts(withThumbnails: false))
      .where((element) {
    if (element.phones == null || element.phones!.isEmpty) return false;
    return isPhoneNoValid(element.phones!.first.value);
  }).toList();

  //Map For save display name against phone number
  final Map<String, String?> newPhoneNos = {};

  //Filtering new contacts
  for (final contact in contacts) {
    String phoneNo = contact.phones!.first.value!.replaceAll(' ', '');
    if (phoneNo[0] == '0') phoneNo = phoneNo.replaceFirst('0', '+92');
    if (chatUsers
        .where((element) => element.phone == phoneNo)
        .toList()
        .isEmpty) {
      newPhoneNos[phoneNo] = contact.displayName;
    }
  }

  if (newPhoneNos.isEmpty) {
    return chatUsers;
  }
  //Make a server request to fetch the Data of these new users
  final response = await apiProv.postReq(body: {
    'phoneNumbers': newPhoneNos.keys.toList(),
  }, url: '$baseUrl/user/getUsersFromPhone');

  if (response.message != null) {
    //Return an error which will trigger the provider error state
    throw response.message!;
  }

  //Converting response data to ChatUser List
  final List<ChatUser> newUsers = (response.data['users'] as List).map((user) {
    return ChatUser.fromMap(user);
  }).toList();

  for (int i = 0; i < newUsers.length; i++) {
    newUsers[i] =
        newUsers[i].copyWith(savedName: newPhoneNos[newUsers[i].phone]);
  }

  //Saving new users to local db
  await localDb.saveChatUsers(newUsers);
  return chatUsers + newUsers;
});
