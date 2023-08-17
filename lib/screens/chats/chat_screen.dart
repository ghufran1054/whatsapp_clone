import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/db_models/chat.dart';
import 'package:whatsapp_clone/screens/chats/chat_tile.dart';

import '../../db_models/chat_user.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key, this.chatUser, this.chat});
  final ChatUser? chatUser;
  final Chat? chat;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          titleSpacing: 0,
          leadingWidth: 60,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Row(
              children: [
                Icon(Icons.arrow_back),
                CircularPhoto(image: null, radius: 15),
              ],
            ),
          ),
          title: ListTile(
            onTap: () {},
            title: Text('Chat',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).appBarTheme.foregroundColor)),
            subtitle: Text(
              'Last seen today at 12:00',
              style: TextStyle(
                  color: Theme.of(context).appBarTheme.foregroundColor),
            ),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.videocam)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Expanded(
              child: Material(
                elevation: 20,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.emoji_emotions_outlined)),
                      const Expanded(
                        child: TextField(
                          maxLines: null,
                          decoration: InputDecoration(
                            constraints: BoxConstraints(maxHeight: 120),
                            hintText: 'Type a message',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.attach_file)),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.camera_alt)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Material(
              color: Colors.transparent,
              child: Ink(
                decoration: ShapeDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: const CircleBorder(),
                ),
                child: IconButton(
                  icon: const Icon(Icons.mic),
                  color: Colors.white,
                  onPressed: () {},
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
