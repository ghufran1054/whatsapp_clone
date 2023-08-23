// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'file_path.dart';
part 'user_model.g.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

@collection
@immutable
class UserModel {
  final Id id = Isar.autoIncrement;
  final String? _id;
  final String? name;
  final String? about;
  final String? phone;
  final FilePath? profilePicUrl;
  final String? token;
  const UserModel({
    String? mId,
    this.name,
    this.about,
    this.phone,
    this.profilePicUrl,
    this.token,
  }) : _id = mId;

  String? get mId => _id;

  UserModel copyWith({
    String? mId,
    String? name,
    String? about,
    String? phone,
    FilePath? profilePicUrl,
    String? token,
  }) {
    return UserModel(
      mId: mId ?? _id,
      name: name ?? this.name,
      about: about ?? this.about,
      phone: phone ?? this.phone,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': _id,
      'name': name,
      'about': about,
      'phone': phone,
      'profilePicUrl': profilePicUrl?.url,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      mId: map['_id'] != null ? map['_id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      about: map['about'] != null ? map['about'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      profilePicUrl: map['profilePicUrl'] != null
          ? FilePath(url: map['profilePicUrl'] as String)
          : null,
      token: map['token'] != null ? map['token'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(_id: $_id, name: $name, about: $about, phone: $phone, profilePicUrl: $profilePicUrl, token: $token)';
  }
}
