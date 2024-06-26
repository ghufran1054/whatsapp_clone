import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:country_picker/country_picker.dart';
import 'package:whatsapp_clone/services/api_services.dart';
import 'package:whatsapp_clone/utils/util_functions.dart';

import '../db_models/user_model.dart';
import '../routes/route_manager.dart';
import '../utils/constants.dart';
import '../widgets/button.dart';
import '../widgets/snackbar.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  Function? setCodeState;
  Country? country;

  void onCountrySelected(Country country) {
    setState(() {
      this.country = country;
    });
  }

  void handleLogin(BuildContext context) async {
    final navigator = Navigator.of(context);
    if (country == null) {
      showSnackbar(context, 'Please select a country');
      return;
    } else if (phoneController.text.isEmpty) {
      showSnackbar(context, 'Please enter a phone number');
      return;
    }
    ref.read(userProvider.notifier).state =
        UserModel(phone: '+${country!.phoneCode}${phoneController.text}');

    final response = await ref
        .read(apiServiceProvider)
        .postReq(url: '$baseUrl/auth/request-otp', body: {
      'phone': ref.read(userProvider.notifier).state!.phone,
    });
    if (response.message != null) {
      // ignore: use_build_context_synchronously
      showSnackbar(context, response.message!);
      return;
    }
    navigator.pushNamed(RouteManger.otpScreen);
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.bold),
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.inversePrimary),
        title: const Text(
          'Enter Your Phone Number',
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
            height: context.height * 0.9,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'WhatsApp will send an SMS message to verify your phone number.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    showCountryPicker(
                        context: context,
                        showPhoneCode: true,
                        onSelect: onCountrySelected);
                  },
                  child: Text(
                    'Choose a country',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StatefulBuilder(builder: (context, setState) {
                      setCodeState = setState;
                      final countryCode = country == null
                          ? ' '
                          : '+${country!.phoneCode.toString()}';
                      return Text(
                        countryCode,
                        style: const TextStyle(fontSize: 17),
                      );
                    }),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        onTapOutside: (event) =>
                            FocusScope.of(context).unfocus(),
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Phone Number',
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 150,
                  child: MyButton(
                    onPressed: () => handleLogin(context),
                    content: 'OK',
                  ),
                )
              ],
            )),
      ),
    );
  }
}
