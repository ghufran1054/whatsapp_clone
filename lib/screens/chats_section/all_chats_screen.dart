import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/providers/chat_providers.dart';
import 'package:whatsapp_clone/utils/util_functions.dart';
import '../../db_models/chat_user.dart';
import '../../providers/chats_provider.dart';
import '../../providers/messages_provider.dart';
import '../../repositories/local_db_repository.dart';
import '../../routes/route_manager.dart';
import 'chat_tile.dart';
import 'dart:math' as math;

class AllChatsScreen extends ConsumerWidget {
  const AllChatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatsProvider);
    final localDb = ref.read(localDbRepositoryProvider);
    return Column(children: [
      Expanded(
        child: ListView.builder(
          itemCount: math.max(chats.length, 1),
          itemBuilder: (context, index) {
            if (chats.isEmpty) {
              return SizedBox(
                height: context.height * 0.8,
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
            ChatUser chatUser = localDb.getUserSync(chat.chatUserId!)!;
            return ChatTile(
              onTap: () async {
                ref.read(selectedChatProvider.notifier).state = chat;
                ref
                    .read(messagesProvider.notifier)
                    .fetchAndSetMessages(chat.mId);
                await Navigator.pushNamed(context, RouteManger.chatScreen);
                ref.read(selectedChatUserData.notifier).state = null;
                log('exited chatScreen');
              },
              image: chatUser.profilePicUrl?.url,
              name: chatUser.savedName ?? chatUser.phone ?? 'Error',
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
