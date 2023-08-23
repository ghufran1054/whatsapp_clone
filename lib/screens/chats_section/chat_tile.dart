import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    this.image,
    required this.name,
    required this.messageCount,
    required this.lastMessage,
    required this.time,
    required this.onTap,
    this.isMuted = false,
  });
  final String? image;
  final String name;
  final int messageCount;
  final String lastMessage;
  final String time;
  final bool isMuted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: onTap,
        leading: CircularPhoto(radius: 25, image: image),
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

class CircularPhoto extends StatelessWidget {
  const CircularPhoto({
    super.key,
    required this.image,
    required this.radius,
  });

  final String? image;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: image == null
          ? Image.asset('assets/dummy_profile.png').image
          : NetworkImage(
              image ?? '',
            ),
      //backgroundColor: Colors.grey,
    );
  }
}
