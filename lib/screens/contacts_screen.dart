import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/db_models/chat_user.dart';
import 'package:whatsapp_clone/routes/route_manager.dart';
import 'package:whatsapp_clone/services/api_services.dart';
import 'package:whatsapp_clone/utils/constants.dart';

import '../repositories/local_db_repository.dart';
import 'chats/chat_tile.dart';

final contactsProvider = FutureProvider<List<ChatUser>>((ref) async {
  final apiProv = ref.read(apiServiceProvider);
  final localDb = ref.read(localDbRepositoryProvider);
  final chatUsers = await localDb.getAllChatUsers(getOnlySaved: true);

  //Checking if a valid Phone number
  final contacts = (await ContactsService.getContacts(withThumbnails: false))
      .where((element) => isPhoneNoValid(element.phones!.first.value))
      .toList();

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

bool isPhoneNoValid(String? phoneno) {
  if (phoneno == null) return false;
  phoneno = phoneno.replaceAll(' ', '');
  final regexp = RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$');
  return regexp.hasMatch(phoneno);
}

class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactProv = ref.watch(contactsProvider);
    if (contactProv.hasError) {
      ref.invalidate(contactsProvider);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Contact'),
      ),
      body: contactProv.when(data: (data) {
        final contacts = data;
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            ChatUser contact = contacts[index];
            return ChatTile(
              onTap: () {
                Navigator.pushNamed(context, RouteManger.chatScreen);
              },
              lastMessage: '',
              name: contact.savedName ?? contact.phone ?? '',
              messageCount: 0,
              time: '',
            );
          },
        );
      }, error: (err, stacktrace) {
        return Center(child: Text(err.toString()));
      }, loading: () {
        return const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
