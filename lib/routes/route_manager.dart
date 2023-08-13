import 'package:flutter/material.dart';
import '../screens/add_info_screen.dart';
import '../screens/homeScreen/home_screen.dart';
import '../screens/landing_screen.dart';
import '../screens/login_screen.dart';
import '../screens/otp_screen.dart';

class RouteManger {
  static const initialRoute = '/';
  static const String landingScreen = '/';
  static const String loginScreen = '/login';
  static const String homeScreen = '/homeSreen';
  static const String addInfoScreen = '/addInfoScreen';
  static const String otpScreen = '/otpScreen';

  //Route handler static function
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case landingScreen:
        return MaterialPageRoute(builder: (_) => const LandingScreen());
      case loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case addInfoScreen:
        return MaterialPageRoute(builder: (_) => const AddInfoScreen());
      case otpScreen:
        return MaterialPageRoute(builder: (_) => const OtpScreen());
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
