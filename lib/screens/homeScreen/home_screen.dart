import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/models/loaded_settings.dart';
import 'package:whatsapp_clone/screens/chats_section/all_chats_screen.dart';
import 'package:whatsapp_clone/utils/util_functions.dart';

import '../../repositories/shared_pref_repo.dart';
import '../../routes/route_manager.dart';
import '../../services/socket_services.dart';
import 'home_tabs_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller =
      TabController(initialIndex: 1, length: 4, vsync: this);

  toggleMode(WidgetRef ref) {
    final sharedPref = ref.read(sharedPrefProvider);
    final settings = ref.read(loadedSettingsStateProvider.notifier);
    final newTheme = settings.state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    sharedPref.setThemeMode(newTheme);
    settings.update((state) => state.copyWith(themeMode: newTheme));
  }

  @override
  void initState() {
    super.initState();
    final socketProvider = ref.read(socketServiceProvider);
    socketProvider.connect();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  snap: true,
                  pinned: true,
                  forceElevated: true,
                  floating: true,
                  flexibleSpace: Row(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Text(
                        'WhatsApp',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).appBarTheme.foregroundColor),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: Theme.of(context).appBarTheme.foregroundColor,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.search,
                          color: Theme.of(context).appBarTheme.foregroundColor,
                        )),
                    IconButton(
                        onPressed: () {
                          toggleMode(ref);
                        },
                        icon: Icon(Icons.more_vert,
                            color:
                                Theme.of(context).appBarTheme.foregroundColor))
                  ]),
                  automaticallyImplyLeading: false,
                  bottom: PreferredSize(
                      preferredSize: Size(context.width, 50),
                      child: HomeScreenTabs(
                        tabController: controller,
                      )),
                )
              ];
            },
            body: TabBarView(controller: controller, children: const [
              Text('Commnnity'),
              AllChatsScreen(),
              Text('Status'),
              Text('Calls'),
            ]),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteManger.contactScreen);
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            child: const Icon(Icons.chat),
          )),
    );
  }
}
