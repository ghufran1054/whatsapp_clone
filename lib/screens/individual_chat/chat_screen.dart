import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/db_models/chat.dart';
import 'package:whatsapp_clone/db_models/chat_user.dart';
import 'package:whatsapp_clone/db_models/message.dart';
import 'package:whatsapp_clone/screens/chats_section/chat_tile.dart';
import 'package:whatsapp_clone/utils/constants.dart';
import 'package:whatsapp_clone/utils/util_functions.dart';
import '../../db_models/user_model.dart';
import '../../providers/chat_message_queue_provider.dart';
import '../../providers/chat_providers.dart';
import '../../providers/chats_provider.dart';
import '../../providers/messages_provider.dart';
import '../../repositories/local_db_repository.dart';
import '../../services/api_services.dart';
import '../../services/socket_services.dart';
import 'chat_input.dart';
import 'message_tile.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController controller = TextEditingController();

  // // Move this Queue to the provider later
  // final Map<int, List<Message>> queue = {};
  void sendMessage(Message message, WidgetRef ref) async {
    controller.clear();
    int chatId = 0;
    final localDb = ref.read(localDbRepositoryProvider);
    final socket = ref.read(socketServiceProvider);
    Chat chat = ref.read(chatProvider)!;
    final apiService = ref.read(apiServiceProvider);
    final queue = ref.read(chatMessageQueueProvider.notifier).state;
    final lastMessageStrings = createLastMessageAndTimeString(message, localDb);
    final chatsProv = ref.read(chatsProvider.notifier);
    chat = chat.copyWith(
      lastMessageString: lastMessageStrings[0],
      lastMessageTime: lastMessageStrings[1],
    );
    //This Means the current chat is already in the queue
    if (queue.containsKey(chat.id)) {
      log('Chat is already in the queue ${chat.id}');
      int id = await ref
          .read(messagesProvider.notifier)
          .addMessage(message, chatId: chat.id);
      queue[chat.id]!.add(message.copyWith(id: id));
      return;
    }
    //Meaning the chat has not been created
    if (chat.mId == null) {
      log('Chat is not created yet ${chat.id}');
      //This adds the chat to state as well as Local DB
      chatId = await chatsProv.addChat(chat);
      chat = chat.copyWith(id: chatId);

      //This adds the message to state as well as Local DB
      int id = await ref
          .read(messagesProvider.notifier)
          .addMessage(message, chatId: chatId);
      queue[chatId] = [message.copyWith(id: id)];
    }
    if (!socket.isConnected) {
      return;
    }

    //If the chat is already created and we're online, send the message to the server
    if (chat.mId != null) {
      log('Chat is already created ${chat.id} with mongoId ${chat.mId}');
      int id = await ref.read(messagesProvider.notifier).addMessage(message);
      chatsProv.updateChat(chat);
      socket.emitEvent('message', message.copyWith(id: id).toMap());
      return;
    }

    //If we're online make the request to the server to create chat
    log('Sending this chat to the server ${chat.id}');
    apiService
        .postReq(body: chat.toMap(), url: '$baseUrl/chat/create')
        .then((response) async {
      if (response.message != null) {
        log(response.message!);
        return;
      }

      //Got the Response from the server and update our state of chats with mongo Id
      final chatmId = response.data['_id'] as String;
      final localId = response.data['id'] as int;

      log('Got the response from the server $localId with mongoId $chatmId');
      final chat = await localDb.getChat(localId);
      final updatedChat = chat!.copyWith(mId: chatmId);
      await chatsProv.updateChat(updatedChat);

      //get the messages for this chat which was being processed, update their chatId and send them to the server
      if (queue.containsKey(localId)) {
        final messages = queue[localId] ?? [];
        queue.remove(localId);
        for (message in messages) {
          message = message.copyWith(chatId: chatmId);
          await localDb.saveMessage(message);
          socket.emitEvent('message', message.toMap());
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chat = ref.watch(chatProvider);
    if (chat == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    final localDb = ref.read(localDbRepositoryProvider);
    ChatUser chatUser = localDb.getUserSync(chat.chatUserId ?? '')!;

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
          child: Row(
            children: [
              const Icon(Icons.arrow_back),
              CircularPhoto(image: chatUser.profilePicUrl?.url, radius: 15),
            ],
          ),
        ),
        title: ListTile(
          onTap: () {},
          title: Text(chatUser.savedName ?? chatUser.phone ?? '',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).appBarTheme.foregroundColor)),
          subtitle: Text(
            'Last seen today at 12:00',
            style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).appBarTheme.foregroundColor),
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.videocam)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final messages = ref.watch(messagesProvider);
                final loggedInUser = ref.read(userProvider);
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    bool isMyMessage =
                        messages[index].senderId == loggedInUser?.mId;
                    return MessageTile(
                      isMyMessage: isMyMessage,
                      showDetails: false,
                      message: messages[index],
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          ChatInput(
              controller: controller,
              onPressed: () {
                String content = controller.text;
                if (content.isEmpty) return;
                Message message = Message(
                  chatId: chat.mId,
                  senderId: ref.read(userProvider)?.mId,
                  content: content,
                  createdAt: DateTime.now().toUtc(),
                  deliveredTo: const [],
                  readBy: const [],
                  messageType: 'text',
                );
                sendMessage(message, ref);
              }),
        ],
      ),
    ));
  }
}
