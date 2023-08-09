import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/models/user.dart';
import 'package:whatsapp_clone/widgets/button.dart';

//TODO: Add a OTP screen before this
class AddInfoScreen extends ConsumerStatefulWidget {
  const AddInfoScreen({super.key});

  @override
  ConsumerState<AddInfoScreen> createState() => _AddInfoScreenState();
}

class _AddInfoScreenState extends ConsumerState<AddInfoScreen> {
  final nameController = TextEditingController();
  final aboutController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Info'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          primary: true,
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/dummy_profile.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  controller: nameController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Name',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  maxLines: 2,
                  maxLength: 100,
                  controller: aboutController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.info),
                    hintText: 'About',
                  ),
                ),
                const Spacer(),
                MyButton(
                    content: 'OK',
                    onPressed: () {
                      ref
                          .read(userProvider.notifier)
                          .update((oldUser) => oldUser!.copyWith(
                                name: nameController.text,
                                about: aboutController.text,
                              ));
                    }),
              ],
            ),
          ),
        ));
  }
}
