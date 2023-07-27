import 'package:flutter/material.dart';
import 'package:whatsapp_clone/screens/homeScreen/home_screen.dart';

import '../screens/landing_screen.dart';
import '../screens/login_screen.dart';

class RouteManger {
  static const initialRoute = homeScreen;
  static const String landingScreen = '/';
  static const String loginScreen = '/login';
  static const String homeScreen = '/homeSreen';

  //Route handler static function
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case landingScreen:
        return MaterialPageRoute(builder: (_) => const LandingScreen());
      case loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
