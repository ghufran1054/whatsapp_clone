import 'package:flutter/material.dart';
import 'package:whatsapp_clone/screens/chats/dummydata.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey,
            child: Image(image: NetworkImage(dummyData[index]['image'])),
          ),
          title: Text(
              "${dummyData[index]['firstName']} ${dummyData[index]['lastName']}"),
          subtitle: Text('Message $index'),
          trailing: Text('Time'),
        );
      },
    );
  }
}
