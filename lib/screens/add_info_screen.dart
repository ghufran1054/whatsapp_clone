import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/utils/util_functions.dart';

import '../db_models/user_model.dart';
import '../repositories/local_db_repository.dart';
import '../routes/route_manager.dart';
import '../services/api_services.dart';
import '../utils/constants.dart';
import '../widgets/button.dart';
import '../widgets/snackbar.dart';

class AddInfoScreen extends ConsumerStatefulWidget {
  const AddInfoScreen({super.key});

  @override
  ConsumerState<AddInfoScreen> createState() => _AddInfoScreenState();
}

class _AddInfoScreenState extends ConsumerState<AddInfoScreen> {
  final nameController = TextEditingController();
  final aboutController = TextEditingController();

  void handleSubmit(WidgetRef ref) async {
    final navigator = Navigator.of(context);
    ref.read(userProvider.notifier).update((oldUser) => oldUser!.copyWith(
          name: nameController.text,
          about: aboutController.text,
        ));
    final response = await ref.read(apiServiceProvider).postReq(
        url: '$baseUrl/auth/sign-up', body: ref.read(userProvider)!.toMap());
    if (response.message != null) {
      // ignore: use_build_context_synchronously
      showSnackbar(context, response.message!);
      return;
    }
    UserModel user = UserModel.fromMap(response.data);
    ref.read(userProvider.notifier).state = user;
    await ref.read(localDbRepositoryProvider).saveLoggedInUser(user);
    navigator.pushNamedAndRemoveUntil(RouteManger.homeScreen, (route) => false);
  }

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
            height: context.height * 0.8,
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
                MyButton(content: 'OK', onPressed: () => handleSubmit(ref)),
              ],
            ),
          ),
        ));
  }
}
