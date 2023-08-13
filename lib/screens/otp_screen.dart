import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/routes/route_manager.dart';
import 'package:whatsapp_clone/services/api_services.dart';

import '../db_models/user_model.dart';
import '../utils/constants.dart';
import '../widgets/snackbar.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  Timer? _timer;
  bool isLoading = false;
  int _seconds = 10;
  void Function(void Function())? setTimerState;
  void Function(void Function())? setLoaderState;

  void startTimer() {
    _seconds = 10;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _timer!.cancel();
      } else {
        setTimerState?.call(() {
          _seconds--;
        });
      }
    });
  }

  void onChange(String value) async {
    if (value.length != 6) return;
    final navigator = Navigator.of(context);

    setLoaderState?.call(() {
      isLoading = true;
    });
    final response = await ref
        .read(apiServiceProvider)
        .postReq(url: '$baseUrl/auth/verify-otp', body: {
      'phone': ref.read(userProvider.notifier).state!.phone,
      'otp': value,
    });
    if (response.message != null) {
      // ignore: use_build_context_synchronously
      showSnackbar(context, response.message!);
      return;
    }
    ref.read(userProvider.notifier).state = UserModel.fromMap(response.data);
    setLoaderState?.call(() {
      isLoading = false;
    });
    response.data['next'] == 'sign-up'
        ? navigator.pushNamedAndRemoveUntil(
            RouteManger.addInfoScreen, (route) => false)
        : navigator.pushNamedAndRemoveUntil(
            RouteManger.homeScreen, (route) => false);
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String phone = ref.watch(userProvider)!.phone ?? '';
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.bold),
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.inversePrimary),
        title: const Text(
          'Enter Your OTP',
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
      body: Stack(children: [
        Container(
            height: MediaQuery.sizeOf(context).height * 0.9,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Please Enter the OTP sent to the number\n$phone',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 150,
                  child: TextField(
                    maxLength: 6,
                    onChanged: onChange,
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: '_ _ _ _ _ _',
                      hintStyle: TextStyle(
                        fontSize: 30,
                      ),
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                StatefulBuilder(builder: (context, setState) {
                  setTimerState = setState;
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _seconds == 0
                              ? 'Press to request OTP'
                              : 'Request OTP again in $_seconds seconds',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: _seconds == 0
                              ? () {
                                  startTimer();
                                  //Send the OTP again
                                }
                              : null,
                          child: const Text(
                            'RESEND',
                          ),
                        ),
                      ]);
                }),
              ],
            )),
        StatefulBuilder(
          builder: (context, setState) {
            setLoaderState = setState;
            return Visibility(
              visible: isLoading,
              child: Container(
                color: Colors.white.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            );
          },
        ),
      ]),
    );
  }
}
