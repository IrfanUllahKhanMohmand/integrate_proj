import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:integration_test/screens/PoetsList/widgets/allPoetsList.dart';
import 'package:integration_test/screens/PoetsList/widgets/nazamList.dart';
import 'package:integration_test/screens/PoetsList/widgets/topPoetsList.dart';
import 'package:integration_test/screens/PoetsList/widgets/ghazalList.dart';
import 'package:integration_test/screens/PoetsList/widgets/sherList.dart';

class TopBarTabs extends StatefulWidget {
  const TopBarTabs({Key? key}) : super(key: key);

  @override
  State<TopBarTabs> createState() => _TopBarTabsState();
}

class _TopBarTabsState extends State<TopBarTabs> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 48,
          child: DefaultTabController(
            length: 4,
            child: Column(
              children: [
                ButtonsTabBar(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  controller: _tabController,
                  backgroundColor: const Color.fromRGBO(93, 86, 250, 0.9),
                  labelStyle: const TextStyle(color: Colors.white),
                  unselectedDecoration:
                      BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(0, 0),
                      color: Colors.grey.withOpacity(0.1),
                    )
                  ]),
                  unselectedLabelStyle:
                      const TextStyle(color: Color.fromRGBO(151, 151, 151, 1)),
                  unselectedBorderColor: Colors.transparent,
                  borderColor: Colors.transparent,
                  radius: 22,
                  tabs: const [
                    Tab(text: 'All'),
                    Tab(text: 'Top Poets'),
                    Tab(text: 'Ghazal'),
                    Tab(text: 'Sher'),
                    Tab(text: 'Nazam'),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .85,
          child: TabBarView(
            controller: _tabController,
            children: [
              const AllPoetsList(),
              TopReadPoetsList(),
              const GhazalList(),
              SherList(),
              NazamList(),
            ],
          ),
        ),
      ],
    );
  }
}
