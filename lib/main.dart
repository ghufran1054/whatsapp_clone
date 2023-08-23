import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:whatsapp_clone/db_models/user_model.dart';
import 'package:whatsapp_clone/routes/route_manager.dart';
import 'package:whatsapp_clone/theme.dart';
import 'services/init_services.dart';
import 'models/loaded_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final provider = ProviderContainer();
  await provider.read(initServicesProvider).init();
  runApp(UncontrolledProviderScope(
    container: provider,
    child: const MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FlutterNativeSplash.remove();
    final settingProv = ref.watch(loadedSettingsStateProvider);
    final userToken = ref.watch(userProvider.select((user) => user?.token));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: settingProv.themeMode ?? ThemeMode.system,
      onGenerateRoute: RouteManger.generateRoute,
      initialRoute: userToken == null
          ? RouteManger.landingScreen
          : RouteManger.homeScreen,
    );
  }
}
