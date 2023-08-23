import 'package:flutter/material.dart';
import 'package:whatsapp_clone/utils/util_functions.dart';

class HomeScreenTabs extends StatelessWidget {
  const HomeScreenTabs({super.key, required this.tabController});
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final yourWidth = context.width;
    final smallTabWidht = yourWidth / 24;
    final bigTabWidth = (yourWidth - smallTabWidht) / 5;
    return Container(
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: TabBar(
          isScrollable: true,
          controller: tabController,
          labelStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Container(
              width: smallTabWidht,
              alignment: Alignment.center,
              child: const Tab(
                icon: Icon(
                  Icons.groups_2,
                ),
              ),
            ),
            Container(
                width: bigTabWidth,
                alignment: Alignment.center,
                child: const Tab(text: "Chats")),
            Container(
                width: bigTabWidth,
                alignment: Alignment.center,
                child: const Tab(text: "Status")),
            Container(
                width: bigTabWidth,
                alignment: Alignment.center,
                child: const Tab(text: "Calls"))
          ]),
    );
  }
}
