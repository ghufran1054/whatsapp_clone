import 'package:flutter/material.dart';
import 'package:whatsapp_clone/utils/util_functions.dart';

import '../routes/route_manager.dart';
import '../widgets/button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: context.height,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Welcome to WhatsApp',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                Image(
                  image: const AssetImage('assets/bg.png'),
                  color: Theme.of(context).colorScheme.primary,
                  height: 350,
                ),
                Column(
                  children: [
                    const Text(
                        'Read our Privacy Policy Tap, "Agree and continue" to accept the Terms of Service',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: context.width * 0.8,
                      child: MyButton(
                        content: 'AGREE AND CONTINUE',
                        onPressed: () {
                          Navigator.pushNamed(context, RouteManger.loginScreen);
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
