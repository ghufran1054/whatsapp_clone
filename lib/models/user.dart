// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateProvider.autoDispose<User?>((ref) => null);

class User {
  final String? uid;
  final String? name;
  final String? about;
  final String? phone;
  final String? profilePicUrl;
  final String? token;
  User({
    this.uid,
    this.name,
    this.about,
    this.phone,
    this.profilePicUrl,
    this.token,
  });

  User copyWith({
    String? uid,
    String? name,
    String? about,
    String? phone,
    String? profilePicUrl,
    String? token,
  }) {
    return User(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      about: about ?? this.about,
      phone: phone ?? this.phone,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'about': about,
      'phone': phone,
      'profilePicUrl': profilePicUrl,
      'token': token,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] != null ? map['uid'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      about: map['about'] != null ? map['about'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      profilePicUrl:
          map['profilePicUrl'] != null ? map['profilePicUrl'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(uid: $uid, name: $name, about: $about, phone: $phone, profilePicUrl: $profilePicUrl, token: $token)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.about == about &&
        other.phone == phone &&
        other.profilePicUrl == profilePicUrl &&
        other.token == token;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        about.hashCode ^
        phone.hashCode ^
        profilePicUrl.hashCode ^
        token.hashCode;
  }
}
