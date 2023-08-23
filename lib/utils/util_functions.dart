import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../db_models/message.dart';
import '../repositories/local_db_repository.dart';

String convertTime(int? hour) {
  if (hour == null) {
    return 'err';
  }
  if (hour < 0 || hour > 23) {
    throw Exception('Invalid hour');
  }
  String amPm = hour < 12 ? 'AM' : 'PM';
  int hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
  return '$hour12 $amPm';
}

bool isPhoneNoValid(String? phoneno) {
  if (phoneno == null) return false;
  phoneno = phoneno.replaceAll(' ', '');
  final regexp = RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$');
  return regexp.hasMatch(phoneno);
}

extension MediaQueryValues on BuildContext {
  double get height => MediaQuery.sizeOf(this).height;
  double get width => MediaQuery.sizeOf(this).width;
  ThemeData get theme => Theme.of(this);
}

//TODO: can be optimized by just checking currentUser.id == message.senderId
List<String> createLastMessageAndTimeString(
    Message message, LocalDbRepository localDb) {
  final user = localDb.getUserSync(message.senderId!);
  //If no user is found for the message.senderId then the message is from the current user
  final messageString =
      '${user?.savedName ?? user?.name ?? 'You'}: ${message.content ?? ''}';

  return [
    messageString,
    DateFormat('h:mm a').format(message.createdAt?.toLocal() ?? DateTime.now()),
  ];
}
