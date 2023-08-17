import 'package:flutter/material.dart';

const primaryColor = Color.fromRGBO(0, 167, 131, 1);
final unselectedColor = Colors.white.withOpacity(0.6);
final darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: const Color.fromRGBO(19, 28, 33, 1),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromRGBO(31, 44, 52, 1),
    foregroundColor: Colors.white,
  ),
  tabBarTheme: TabBarTheme(
      labelColor: primaryColor,
      unselectedLabelColor: unselectedColor,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(
          color: primaryColor,
          width: 3.0,
        ),
        insets: EdgeInsets.symmetric(horizontal: 16.0),
      )),
  colorScheme: ColorScheme.fromSeed(
      onSecondaryContainer: const Color.fromRGBO(31, 44, 52, 1),
      brightness: Brightness.dark,
      inversePrimary: Colors.white,
      seedColor: const Color.fromRGBO(31, 44, 52, 1),
      primary: primaryColor,
      secondary: Colors.grey[400]),
);

final lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(5, 96, 98, 1),
      foregroundColor: Colors.white,
    ),
    tabBarTheme: TabBarTheme(
        labelColor: Colors.white,
        unselectedLabelColor: unselectedColor,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(
            color: Colors.white,
            width: 3.0,
          ),
          insets: EdgeInsets.symmetric(horizontal: 16.0),
        )),
    colorScheme: ColorScheme.fromSeed(
        onSecondaryContainer: Colors.white,
        seedColor: const Color.fromRGBO(31, 44, 52, 1),
        inversePrimary: Colors.black,
        primary: primaryColor,
        secondary: Colors.grey[400]));

const backgroundColor = Color.fromRGBO(19, 28, 33, 1);
const textColor = Color.fromRGBO(241, 241, 242, 1);
const appBarColor = Color.fromRGBO(31, 44, 52, 1);
const messageColor = Color.fromRGBO(5, 96, 98, 1);
const senderMessageColor = Color.fromRGBO(37, 45, 49, 1);
const tabColor = Color.fromRGBO(0, 167, 131, 1);
const searchBarColor = Color.fromRGBO(50, 55, 57, 1);
const dividerColor = Color.fromRGBO(37, 45, 50, 1);
const chatBarMessage = Color.fromRGBO(30, 36, 40, 1);
const mobileChatBoxColor = Color.fromRGBO(31, 44, 52, 1);
