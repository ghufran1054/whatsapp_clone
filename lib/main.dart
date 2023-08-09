import 'package:flutter/material.dart';
import 'package:whatsapp_clone/routes/route_manager.dart';
import 'package:whatsapp_clone/theme.dart';
import 'screens/landing_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      home: const LandingScreen(),
      onGenerateRoute: RouteManger.generateRoute,
      initialRoute: RouteManger.initialRoute,
    );
  }
}
