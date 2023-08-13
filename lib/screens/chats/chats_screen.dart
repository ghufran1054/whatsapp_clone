import 'dart:math';

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/screens/chats/dummydata.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) {
            return ChatTile(
              image: "${dummyData[index]['image']}}",
              name:
                  "${dummyData[index]['firstName']} ${dummyData[index]['lastName']}",
              messageCount: Random().nextInt(2),
              lastMessage:
                  'Hello Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              time: '12:00 PM',
              isMuted: Random().nextBool(),
            );
          },
        ),
      ),
    ]);
  }
}

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.image,
    required this.name,
    required this.messageCount,
    required this.lastMessage,
    required this.time,
    this.isMuted = false,
  });
  final String image;
  final String name;
  final int messageCount;
  final String lastMessage;
  final String time;
  final bool isMuted;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {},
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(
            image,
          ),
          //backgroundColor: Colors.grey,
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          lastMessage,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              time,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 20,
              width: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  isMuted
                      ? const Icon(
                          Icons.volume_off_sharp,
                          size: 20,
                        )
                      : const SizedBox(),
                  const SizedBox(
                    width: 5,
                  ),
                  messageCount != 0
                      ? CircleAvatar(
                          radius: 10,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          child: Text(
                            messageCount.toString(),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            )
          ],
        ));
  }
}
