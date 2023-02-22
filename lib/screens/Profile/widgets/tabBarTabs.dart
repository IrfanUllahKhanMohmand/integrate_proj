import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:integration_test/screens/Profile/widgets/ghazalsTabView.dart';
import 'package:integration_test/screens/Profile/widgets/profilesTabView.dart';
import 'package:integration_test/screens/Profile/widgets/sherTabView.dart';

import 'nazamTabView.dart';

class TabBarTabs extends StatefulWidget {
  const TabBarTabs({Key? key}) : super(key: key);

  @override
  State<TabBarTabs> createState() => _TabBarTabsState();
}

class _TabBarTabsState extends State<TabBarTabs> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: ButtonsTabBar(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            controller: _tabController,
            backgroundColor: const Color.fromRGBO(93, 86, 250, 0.9),
            labelStyle: const TextStyle(color: Colors.white),
            unselectedLabelStyle:
                const TextStyle(color: Color.fromRGBO(151, 151, 151, 1)),
            // unselectedBorderColor: Colors.white,
            unselectedDecoration:
                BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                spreadRadius: 0,
                blurRadius: 2,
                offset: const Offset(0, 0),
                color: Colors.grey.withOpacity(0.1),
              )
            ]),
            borderColor: Colors.transparent,
            radius: 22,
            tabs: const [
              Tab(
                text: 'PROFILE',
              ),
              Tab(text: 'NAZAM'),
              Tab(text: 'SHER'),
              Tab(text: 'GHAZAL')
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .58,
          child: TabBarView(
            controller: _tabController,
            children: const [
              ProfilesTabView(),
              NazamsTabView(),
              SherTabView(),
              GhazalsTabView()
            ],
          ),
        ),
      ],
    );
  }
}
