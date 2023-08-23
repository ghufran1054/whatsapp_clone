// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import 'file_path.dart';

part 'chat_user.g.dart';

@collection
@immutable
class ChatUser {
  final Id id;
  @Index(composite: [CompositeIndex('phone')])
  final String? _id;
  final String? name;
  final String? savedName;
  final String? phone;
  final FilePath? profilePicUrl;
  final String? about;
  const ChatUser({
    String? mId,
    this.id = Isar.autoIncrement,
    this.name,
    this.savedName,
    this.phone,
    this.profilePicUrl,
    this.about,
  }) : _id = mId;
  String? get mId => _id;

  ChatUser copyWith({
    Id? id,
    String? mId,
    String? name,
    String? savedName,
    String? phone,
    FilePath? profilePicUrl,
    String? about,
  }) {
    return ChatUser(
      id: id ?? this.id,
      mId: mId ?? _id,
      name: name ?? this.name,
      savedName: savedName ?? this.savedName,
      phone: phone ?? this.phone,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      about: about ?? this.about,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': _id,
      'name': name,
      'savedName': savedName,
      'phone': phone,
      'profilePicUrl': profilePicUrl?.url,
      'about': about,
    };
  }

  factory ChatUser.fromMap(Map<String, dynamic> map) {
    return ChatUser(
      mId: map['_id'] != null ? map['_id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      savedName: map['savedName'] != null ? map['savedName'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      about: map['about'] != null ? map['about'] as String : null,
      profilePicUrl: map['profilePicUrl'] != null
          ? FilePath(url: map['profilePicUrl'] as String)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatUser.fromJson(String source) =>
      ChatUser.fromMap(json.decode(source) as Map<String, dynamic>);
}
