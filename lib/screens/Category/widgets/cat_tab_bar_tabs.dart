import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:integration_test/model/category.dart';
import 'package:integration_test/screens/Category/widgets/cat_ghazals_tab_view.dart';
import 'package:integration_test/screens/Category/widgets/cat_nazam_tab_view.dart';
import 'package:integration_test/screens/Category/widgets/cat_profiles_tab_view.dart';
import 'package:integration_test/screens/Category/widgets/cat_sher_tab_view.dart';

class CategoryTabBarTabs extends StatefulWidget {
  const CategoryTabBarTabs(
      {Key? key,
      required this.cat,
      required this.nazams,
      required this.ghazals,
      required this.shers})
      : super(key: key);
  final Category cat;
  final List nazams;
  final List ghazals;
  final List shers;

  @override
  State<CategoryTabBarTabs> createState() => _CategoryTabBarTabsState();
}

class _CategoryTabBarTabsState extends State<CategoryTabBarTabs>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
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
                Tab(text: 'PROFILE'),
                Tab(text: 'NAZAM'),
                Tab(text: 'SHER'),
                Tab(text: 'GHAZAL')
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                CategoryProfilesTabView(category: widget.cat),
                CategoryNazamsTabView(
                    nazams: widget.nazams, category: widget.cat),
                CategorySherTabView(shers: widget.shers, cat: widget.cat),
                CategoryGhazalsTabView(ghazals: widget.ghazals, cat: widget.cat)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
