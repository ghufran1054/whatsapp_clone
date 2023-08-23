// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import 'file_path.dart';

part 'chat.g.dart';

@collection
@immutable
class Chat {
  final Id id;

  final String? _id;
  final bool? isGroup;
  final int? unreadCount;
  final String? lastMessageString;
  final String? lastMessageTime;
  final String? chatUserId;
  final DateTime? lastSeen;
  @Index()
  String? get mId => _id;

  //This will be non-null only if the chat is a group
  final List<String> members;
  final GroupData? groupData;

  const Chat({
    String? mId,
    this.id = Isar.autoIncrement,
    this.unreadCount,
    this.chatUserId,
    this.isGroup,
    this.groupData,
    this.lastMessageString,
    this.lastMessageTime,
    this.lastSeen,
    this.members = const [],
  }) : _id = mId;

  Chat copyWith({
    int? id,
    String? mId,
    bool? isGroup,
    GroupData? groupData,
    int? unreadCount,
    String? lastMessageString,
    String? lastMessageTime,
    String? chatUserId,
    DateTime? lastSeen,
    List<String>? members,
  }) {
    return Chat(
      id: id ?? this.id,
      mId: mId ?? _id,
      isGroup: isGroup ?? this.isGroup,
      groupData: groupData ?? this.groupData,
      unreadCount: unreadCount ?? this.unreadCount,
      lastMessageString: lastMessageString ?? this.lastMessageString,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      chatUserId: chatUserId ?? this.chatUserId,
      lastSeen: lastSeen ?? this.lastSeen,
      members: members ?? this.members,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': _id,
      'id': id,
      'isGroup': isGroup,
      'unreadCount': unreadCount,
      'lastMessageString': lastMessageString,
      'lastMessageTime': lastMessageTime,
      'chatUserId': chatUserId,
      'lastSeen': lastSeen?.toIso8601String(),
      'members': members,
      'groupData': groupData?.toMap(),
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    final members = (map['members'] as List<dynamic>);
    return Chat(
      groupData: map['groupData'] != null
          ? GroupData.fromMap(map['groupData'] as Map<String, dynamic>)
          : null,
      mId: map['_id'] != null ? map['_id'] as String : null,
      isGroup: map['isGroup'] != null ? map['isGroup'] as bool : null,
      unreadCount:
          map['unreadCount'] != null ? map['unreadCount'] as int : null,
      lastMessageString: map['lastMessageString'] != null
          ? map['lastMessageString'] as String
          : null,
      lastMessageTime: map['lastMessageTime'] != null
          ? map['lastMessageTime'] as String
          : null,
      chatUserId:
          map['chatUserId'] != null ? map['chatUserId'] as String : null,
      lastSeen: map['lastSeen'] != null
          ? DateTime.parse(map['lastSeen'] as String)
          : null,
      members: <String>[for (final member in members) member as String],
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) =>
      Chat.fromMap(json.decode(source) as Map<String, dynamic>);
}

@embedded
class GroupData {
  final String? name;
  final String? description;
  final FilePath? groupPicUrl;
  final DateTime? createdOn;
  final String? createdByUserId;
  final List<String> admins;
  const GroupData({
    this.name,
    this.description,
    this.groupPicUrl,
    this.createdOn,
    this.createdByUserId,
    this.admins = const [],
  });

  GroupData copyWith({
    String? name,
    String? description,
    FilePath? groupPicUrl,
    DateTime? createdOn,
    String? createdByUserId,
    List<String>? admins,
  }) {
    return GroupData(
      name: name ?? this.name,
      description: description ?? this.description,
      groupPicUrl: groupPicUrl ?? this.groupPicUrl,
      createdOn: createdOn ?? this.createdOn,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      admins: admins ?? this.admins,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'groupPicUrl': groupPicUrl?.url,
      'createdOn': createdOn?.toIso8601String(),
      'createdByUserId': createdByUserId,
      'admins': admins,
    };
  }

  factory GroupData.fromMap(Map<String, dynamic> map) {
    return GroupData(
        name: map['name'] != null ? map['name'] as String : null,
        description:
            map['description'] != null ? map['description'] as String : null,
        groupPicUrl: map['groupPicUrl'] != null
            ? FilePath(url: map['groupPicUrl'] as String)
            : null,
        createdOn: map['createdOn'] != null
            ? DateTime.parse(map['createdOn'] as String)
            : null,
        createdByUserId: map['createdByUserId'] != null
            ? map['createdByUserId'] as String
            : null,
        admins: List<String>.from(
          (map['admins'] as List<String>),
        ));
  }

  String toJson() => json.encode(toMap());

  factory GroupData.fromJson(String source) =>
      GroupData.fromMap(json.decode(source) as Map<String, dynamic>);
}
