import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.content, required this.onPressed});
  final String content;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          fixedSize: const Size(double.infinity, 50),
          backgroundColor: Theme.of(context).colorScheme.primary),
      child: Text(content),
    );
  }
}
