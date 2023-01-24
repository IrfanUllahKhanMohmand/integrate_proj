import 'package:flutter/material.dart';
import 'package:integration_test/screens/Profile/widgets/ghazalsTabView.dart';
import 'package:integration_test/screens/Profile/widgets/profilesTabView.dart';
import 'package:integration_test/screens/Profile/widgets/sherTabView.dart';

import 'nazamTabView.dart';

class TabBarTabs extends StatefulWidget {
  TabBarTabs({Key? key}) : super(key: key);

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
        const Divider(
          color: Colors.white,
          thickness: 1,
        ),
        SizedBox(
          height: 50,
          child: TabBar(
            controller: _tabController,
            indicatorWeight: 4,
            indicatorSize: TabBarIndicatorSize.label,
            isScrollable: true,
            tabs: const [
              Tab(
                child: Text('PROFILE'),
              ),
              Tab(
                child: Text('GHAZAL'),
              ),
              Tab(
                child: Text('NAZAM'),
              ),
              Tab(
                child: Text('SHER'),
              ),
            ],
          ),
        ),
        const Divider(
          color: Colors.white,
          thickness: 1,
        ),
        SizedBox(
          height: 400,
          child: TabBarView(
            controller: _tabController,
            children: const [
              ProfilesTabView(),
              GhazalsTabView(),
              NazamsTabView(),
              SherTabView()
            ],
          ),
        ),
      ],
    );
  }
}
