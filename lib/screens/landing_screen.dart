import 'package:flutter/material.dart';
import 'package:whatsapp_clone/routes/route_manager.dart';
import 'package:whatsapp_clone/widgets/button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.sizeOf(context).height,
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
                      width: MediaQuery.sizeOf(context).width * 0.8,
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
