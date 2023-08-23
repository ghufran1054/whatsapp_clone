// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:whatsapp_clone/db_models/chat.dart';
import 'package:whatsapp_clone/providers/chat_providers.dart';

import '../db_models/message.dart';
import '../db_models/user_model.dart';
import '../providers/messages_provider.dart';
import '../repositories/local_db_repository.dart';
import '../utils/constants.dart';
import '../utils/util_functions.dart';
import 'api_services.dart';

final socketServiceProvider = Provider((ref) {
  final token = ref.watch(userProvider)?.token ?? '';

  final socket = io.io(baseUrl, <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
    'extraHeaders': {'authorization': token}
  });
  return SocketService(socket: socket, ref: ref);
});

class SocketService {
  io.Socket socket;
  bool isConnected = false;
  Timer? timer;
  final Ref ref;
  SocketService({
    required this.ref,
    required this.socket,
  });

  void sendQueuedMessages() async {
    final localDb = ref.read(localDbRepositoryProvider);
    final chats = await localDb.getQueuedChats();
    final apiService = ref.read(apiServiceProvider);
    for (final chat in chats) {
      final response = await apiService.postReq(
          body: chat.toMap(), url: '$baseUrl/chats/create');
      if (response.message != null) {
        log(response.message!);
      }
      int localId = response.data['id'];
      String mId = response.data['_id'];
      final newChat = (await localDb.getChat(localId))!.copyWith(mId: mId);
      await localDb.saveChat(newChat);
      await localDb.updateMessagesChatId(localId, mId);
    }
    final messages =
        ref.read(localDbRepositoryProvider).getQueuedMessagesSync();
    for (final message in messages) {
      socket.emit('message', message.toMap());
    }
  }

  void connect() {
    socket.connect();
    socket.onConnect((_) {
      if (timer == null) {
        timer = Timer(Duration.zero, () {
          isConnected = true;
        });
        return;
      }
      timer = Timer(const Duration(seconds: 2), () {
        isConnected = true;
        //sendQueuedMessages();
      });
    });

    socket.onDisconnect((data) {
      isConnected = false;
      timer?.cancel();
    });

    socket.onError((data) => log(data.toString()));
    socket.onConnectError((data) => log(data.toString()));
    socket.on('messageResponse', handleMessageResponse);
    socket.on('message', handleIncomingMessage);
  }

  //TODO: Handle incoming message
  void handleIncomingMessage(dynamic data) async {
    final message = Message.fromMap(data);
    final chatmId = message.chatId;
    final localDb = ref.read(localDbRepositoryProvider);
    //final apiService = ref.read(apiServiceProvider);
    final chat = await localDb.getChatbymId(chatmId!);
    if (chat == null) {
      log('chat not found fetch chat from server');
      //TODO: create the get chat by id api
      //final response = await apiService.getReq(url: '$baseUrl/chats/$chatmId');
      //create last message string and time and copy with here
      //final chat = Chat.fromMap(response.data).copyWith(...);
      //await localDb.saveChat(chat);
    }
    final currentChat = ref.read(chatProvider);

    //If the chat is opened for which message came update the messages List
    if (currentChat != null && currentChat.mId == chatmId) {
      log('updating message in current chat');
      await ref.read(messagesProvider.notifier).updateMessage(message);
    } else {
      //Save the message to local db
      await localDb.saveMessage(message);
    }
  }

  void handleMessageResponse(dynamic data) async {
    log('Message Response: ${data.toString()}');
    final localDb = ref.read(localDbRepositoryProvider);
    final message = Message.fromMap(data).copyWith(status: 'sent');
    final chatId = message.chatId;
    final currentChat = ref.read(chatProvider);

    //If the chat is opened for which message came update the messages List
    if (currentChat != null && currentChat.mId == chatId) {
      log('updating message in current chat');
      await ref.read(messagesProvider.notifier).updateMessage(message);
    } else {
      //Save the message to local db
      await localDb.saveMessage(message);
    }

    //Update the last message and time of the chat and save it to local db
    Chat chat = (await localDb.getChatbymId(chatId!))!;
    final lastMessageStrings = createLastMessageAndTimeString(message, localDb);
    chat = chat.copyWith(
      lastMessageString: lastMessageStrings[0],
      lastMessageTime: lastMessageStrings[1],
    );
    await localDb.saveChat(chat);
  }

  void emitEvent(String event, dynamic data) {
    socket.emit(event, data);
  }
}
