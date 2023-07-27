import 'package:flutter/material.dart';
import 'package:whatsapp_clone/screens/chats/chats_screen.dart';

import 'home_tabs_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller =
      TabController(initialIndex: 1, length: 4, vsync: this);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                snap: true,
                pinned: true,
                //forceElevated: true,
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
                          color: Theme.of(context).appBarTheme.foregroundColor),
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
                      onPressed: () {},
                      icon: Icon(Icons.more_vert,
                          color: Theme.of(context).appBarTheme.foregroundColor))
                ]),
                automaticallyImplyLeading: false,
                bottom: PreferredSize(
                    preferredSize: Size(size.width, 50),
                    child: HomeScreenTabs(
                      tabController: controller,
                    )),
              )
            ];
          },
          body: TabBarView(controller: controller, children: const [
            Text('Commnnity'),
            ChatScreen(),
            Text('Status'),
            Text('Calls'),
          ]),
        ),
      ),
    );
  }
}
