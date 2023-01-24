import 'package:flutter/material.dart';
import 'package:integration_test/screens/PoetsList/widgets/allPoetsList.dart';
import 'package:integration_test/screens/PoetsList/widgets/topReadPoetsList.dart';
import 'package:integration_test/screens/PoetsList/widgets/womenPoetsList.dart';
import 'package:integration_test/screens/PoetsList/widgets/youngPoetsList.dart';

class TopBarTabs extends StatefulWidget {
  TopBarTabs({Key? key}) : super(key: key);

  @override
  State<TopBarTabs> createState() => _TopBarTabsState();
}

class _TopBarTabsState extends State<TopBarTabs> with TickerProviderStateMixin {
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
                child: Text('ALL'),
              ),
              Tab(
                child: Text('TOP-READ'),
              ),
              Tab(
                child: Text('WOMEN POETS'),
              ),
              Tab(
                child: Text('YOUNG POETS'),
              ),
            ],
          ),
        ),
        const Divider(
          color: Colors.white,
          thickness: 1,
        ),
        SizedBox(
          height: 500,
          child: TabBarView(
            controller: _tabController,
            children: [
              AllPoetsList(),
              TopReadPoetsList(),
              WomenPoetsList(),
              YoungPoetsList(),
            ],
          ),
        ),
      ],
    );
  }
}
