import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/chats_notifier.dart';
import 'chat_tile.dart';

class AllChatsScreen extends ConsumerWidget {
  const AllChatsScreen({super.key});

  String convertTime(int? hour) {
    if (hour == null) {
      return 'Error';
    }
    if (hour < 0 || hour > 23) {
      throw Exception('Invalid hour');
    }
    String amPm = hour < 12 ? 'AM' : 'PM';
    int hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$hour12 $amPm';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatsProvider);
    return Column(children: [
      Expanded(
        child: ListView.builder(
          itemCount: max(chats.length, 1),
          itemBuilder: (context, index) {
            if (chats.isEmpty) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/chat_icon.png',
                        height: 140,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'No Chats Yet, Click contacts to start a chat!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ),
              );
            }
            final chat = chats[index];
            chat.userData.loadSync();

            return ChatTile(
              onTap: () {},
              image: chats[index].userData.value!.profilePicUrl,
              name: chat.userData.value!.savedName ??
                  chat.userData.value!.phone ??
                  'Error',
              messageCount: chat.unreadCount ?? 0,
              lastMessage: chat.lastMessageString ?? '',
              time: chat.lastMessageTime ?? '',
              isMuted: false,
            );
          },
        ),
      ),
    ]);
  }
}
