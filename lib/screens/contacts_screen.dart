import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/db_models/chat_user.dart';
import 'package:whatsapp_clone/routes/route_manager.dart';
import '../providers/chat_providers.dart';
import '../providers/contacts_provider.dart';
import '../providers/messages_provider.dart';
import 'chats_section/chat_tile.dart';

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
              onTap: () async {
                ref.read(selectedChatUserData.notifier).state = contact;
                final chat = ref.read(chatProvider)!;
                ref
                    .read(messagesProvider.notifier)
                    .fetchAndSetMessages(chat.mId);

                await Navigator.pushNamed(context, RouteManger.chatScreen);
                ref.read(selectedChatUserData.notifier).state = null;
                log('exited chatScreen');
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
