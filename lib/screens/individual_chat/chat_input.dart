import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hasTextProvider = StateProvider.autoDispose((ref) {
  return false;
});
final sendButtonProvider = Provider.autoDispose((ref) {
  return ref.watch(hasTextProvider) == true ? Icons.send : Icons.mic;
});

class ChatInput extends ConsumerWidget {
  const ChatInput(
      {super.key, required this.controller, required this.onPressed});
  final TextEditingController controller;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Expanded(
          child: Material(
            elevation: 20,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.emoji_emotions_outlined)),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      maxLines: null,
                      onChanged: (value) {
                        ref.read(hasTextProvider.notifier).state =
                            value.isNotEmpty;
                      },
                      decoration: const InputDecoration(
                        constraints: BoxConstraints(maxHeight: 120),
                        hintText: 'Type a message',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.attach_file)),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.camera_alt)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),
        SendButton(
          onPressed: onPressed,
        ),
      ]),
    );
  }
}

class SendButton extends ConsumerWidget {
  const SendButton({super.key, required this.onPressed});
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: Ink(
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: const CircleBorder(),
        ),
        child: IconButton(
          icon: Icon(ref.watch(sendButtonProvider)),
          color: Colors.white,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
