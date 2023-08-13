// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import 'chat_user.dart';

part 'chat.g.dart';

@collection
@immutable
class Chat {
  final Id id = Isar.autoIncrement;
  final String? _id;
  final bool? isGroup;
  String? get mId => _id;

  //This will be non-null only if the chat is a group
  final GroupData? groupData;

  //The Data of the single user, if the chat is not a group
  final userData = IsarLink<ChatUser>();

  final members = IsarLinks<ChatUser>();
  final admins = IsarLinks<ChatUser>();

  Chat({
    String? mId,
    this.isGroup,
    this.groupData,
  }) : _id = mId;

  Chat copyWith({
    String? mId,
    bool? isGroup,
    GroupData? groupData,
  }) {
    return Chat(
      mId: mId ?? _id,
      isGroup: isGroup ?? this.isGroup,
      groupData: groupData ?? this.groupData,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': _id,
      'isGroup': isGroup,
      'groupData': groupData?.toMap(),
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      mId: map['_id'] != null ? map['_id'] as String : null,
      isGroup: map['isGroup'] != null ? map['isGroup'] as bool : null,
      groupData: map['groupData'] != null
          ? GroupData.fromMap(map['groupData'] as Map<String, dynamic>)
          : null,
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
  final String? groupPicUrl;
  final DateTime? createdOn;
  final String? createdByUserId;
  const GroupData({
    this.name,
    this.description,
    this.groupPicUrl,
    this.createdOn,
    this.createdByUserId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'groupPicUrl': groupPicUrl,
      'createdOn': createdOn?.millisecondsSinceEpoch,
      'createdByUserId': createdByUserId,
    };
  }

  factory GroupData.fromMap(Map<String, dynamic> map) {
    return GroupData(
      name: map['name'] != null ? map['name'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      groupPicUrl:
          map['groupPicUrl'] != null ? map['groupPicUrl'] as String : null,
      createdOn: map['createdOn'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdOn'] as int)
          : null,
      createdByUserId: map['createdByUserId'] != null
          ? map['createdByUserId'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupData.fromJson(String source) =>
      GroupData.fromMap(json.decode(source) as Map<String, dynamic>);

  GroupData copyWith({
    String? name,
    String? description,
    String? groupPicUrl,
    DateTime? createdOn,
    String? createdByUserId,
  }) {
    return GroupData(
      name: name ?? this.name,
      description: description ?? this.description,
      groupPicUrl: groupPicUrl ?? this.groupPicUrl,
      createdOn: createdOn ?? this.createdOn,
      createdByUserId: createdByUserId ?? this.createdByUserId,
    );
  }
}