import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/utils/util_functions.dart';

import '../../db_models/chat_user.dart';
import '../../db_models/message.dart';
import '../../repositories/local_db_repository.dart';

class MessageTile extends ConsumerWidget {
  const MessageTile(
      {required this.message,
      required this.isMyMessage,
      this.showDetails = false,
      super.key});

  final bool isMyMessage;
  final bool showDetails;
  final Message message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localDb = ref.read(localDbRepositoryProvider);
    ChatUser? chatUser;
    if (showDetails) {
      chatUser = localDb.getUserSync(message.senderId ?? '');
    }
    return Container(
      alignment: !isMyMessage ? Alignment.centerLeft : Alignment.centerRight,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Material(
        elevation: 2,
        color: isMyMessage
            ? Theme.of(context).colorScheme.onPrimaryContainer
            : Theme.of(context).colorScheme.onSecondaryContainer,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10),
          topRight: const Radius.circular(10),
          bottomLeft: isMyMessage ? const Radius.circular(10) : Radius.zero,
          bottomRight: isMyMessage ? Radius.zero : const Radius.circular(10),
        ),
        child: Container(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 3),
          constraints:
              BoxConstraints(maxWidth: context.width * 0.6, minWidth: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showDetails)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        chatUser?.name ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      chatUser?.phone ?? '',
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              Text(message.content ?? ''),
              SizedBox(
                width: (message.content?.length.toDouble() ?? 0) * 5 + 50,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    message.status != 'queued'
                        ? Text(
                            DateFormat('h:mm a').format(
                                message.createdAt?.toLocal() ??
                                    DateTime.now().toUtc()),
                            style: const TextStyle(fontSize: 10),
                          )
                        : const SizedBox(),
                    const SizedBox(width: 3),
                    isMyMessage
                        ? Icon(
                            message.status == 'queued'
                                ? Icons.access_time
                                : message.status == 'sent'
                                    ? Icons.check
                                    : Icons.done_all,
                            size: 15,
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
