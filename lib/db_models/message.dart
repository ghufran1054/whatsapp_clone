// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

import 'file_path.dart';

part 'message.g.dart';

@collection
@immutable
class Message {
  //Add other fields in next iteration
  final Id id;
  final String? _id;
  @Index(composite: [CompositeIndex('createdAt')])
  final String? chatId;
  final String? senderId;
  final String? messageType;
  final String? content;
  final FilePath? fileUrl;
  final String? status;
  final DateTime? createdAt;
  final List<String> readBy;
  final List<String> deliveredTo;

  const Message({
    this.id = Isar.autoIncrement,
    String? mId,
    this.chatId,
    this.senderId,
    this.messageType,
    this.content,
    this.fileUrl,
    this.createdAt,
    this.status = "queued",
    this.readBy = const [],
    this.deliveredTo = const [],
  }) : _id = mId;

  String? get mId => _id;

  Message copyWith({
    int? id,
    String? mId,
    String? chatId,
    String? senderId,
    String? messageType,
    String? content,
    FilePath? fileUrl,
    String? status,
    DateTime? createdAt,
    List<String>? readBy,
    List<String>? deliveredTo,
  }) {
    return Message(
      id: id ?? this.id,
      mId: mId ?? _id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      messageType: messageType ?? this.messageType,
      content: content ?? this.content,
      fileUrl: fileUrl ?? this.fileUrl,
      createdAt: createdAt ?? this.createdAt,
      readBy: readBy ?? this.readBy,
      deliveredTo: deliveredTo ?? this.deliveredTo,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      '_id': _id,
      'chatId': chatId,
      'senderId': senderId,
      'messageType': messageType,
      'content': content,
      'fileUrl': fileUrl?.url,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'readBy': readBy,
      'deliveredTo': deliveredTo,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    final deliveredTo = (map['deliveredTo'] as List<dynamic>);
    final readBy = (map['readBy'] as List<dynamic>);
    return Message(
        id: map['id'] != null ? map['id'] as int : Isar.autoIncrement,
        mId: map['_id'] != null ? map['_id'] as String : null,
        chatId: map['chatId'] != null ? map['chatId'] as String : null,
        senderId: map['senderId'] != null ? map['senderId'] as String : null,
        messageType:
            map['messageType'] != null ? map['messageType'] as String : null,
        content: map['content'] != null ? map['content'] as String : null,
        fileUrl: map['fileUrl'] != null
            ? FilePath(url: map['fileUrl'] as String)
            : null,
        status: map['status'] != null ? map['status'] as String : null,
        createdAt: map['createdAt'] != null
            ? DateTime.parse(map['createdAt'] as String)
            : null,
        readBy: <String>[for (final item in readBy) item as String],
        deliveredTo: <String>[for (final item in deliveredTo) item as String]);
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);
}
