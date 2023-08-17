// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

part 'message.g.dart';

@collection
@immutable
class Message {
  //Add other fields in next iteration
  final Id id = Isar.autoIncrement;
  final String? _id;
  final String? chatId;
  final String? senderId;
  final String? messageType;
  final String? content;
  final String? fileUrl;
  final DateTime? createdAt;
  const Message({
    String? mId,
    this.chatId,
    this.senderId,
    this.messageType,
    this.content,
    this.fileUrl,
    this.createdAt,
  }) : _id = mId;

  String? get mId => _id;

  Message copyWith({
    String? mId,
    String? chatId,
    String? senderId,
    String? messageType,
    String? content,
    String? fileUrl,
    DateTime? createdAt,
  }) {
    return Message(
      mId: mId ?? _id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      messageType: messageType ?? this.messageType,
      content: content ?? this.content,
      fileUrl: fileUrl ?? this.fileUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
