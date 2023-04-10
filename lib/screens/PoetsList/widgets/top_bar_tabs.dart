import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:integration_test/model/category.dart';
import 'package:integration_test/model/ghazal.dart';
import 'package:integration_test/model/nazam.dart';
import 'package:integration_test/model/poet.dart';
import 'package:integration_test/model/sher.dart';
import 'package:integration_test/screens/PoetsList/widgets/all_poets_list.dart';
import 'package:integration_test/screens/PoetsList/widgets/nazam_list.dart';
import 'package:integration_test/screens/PoetsList/widgets/top_poets_list.dart';
import 'package:integration_test/screens/PoetsList/widgets/ghazal_list.dart';
import 'package:integration_test/screens/PoetsList/widgets/sher_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TopBarTabs extends StatefulWidget {
  const TopBarTabs(
      {Key? key,
      required this.poets,
      required this.categories,
      required this.nazams,
      required this.ghazals,
      required this.shers,
      required this.trendingShers})
      : super(key: key);
  final List<Poet> poets;
  final List<Category> categories;
  final List<Nazam> nazams;
  final List<Ghazal> ghazals;
  final List<Sher> shers;
  final List trendingShers;
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
    return Expanded(
      child: Column(
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
                    unselectedLabelStyle: const TextStyle(
                        color: Color.fromRGBO(151, 151, 151, 1)),
                    unselectedBorderColor: Colors.transparent,
                    borderColor: Colors.transparent,
                    radius: 22,
                    tabs: [
                      Tab(text: AppLocalizations.of(context)!.all),
                      Tab(text: AppLocalizations.of(context)!.top_poets),
                      Tab(text: AppLocalizations.of(context)!.ghazals),
                      Tab(text: AppLocalizations.of(context)!.shers),
                      Tab(text: AppLocalizations.of(context)!.nazams),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                AllPoetsList(
                  poets: widget.poets,
                  categories: widget.categories,
                  trendingShers: widget.trendingShers,
                ),
                TopReadPoetsList(poets: widget.poets),
                GhazalList(ghazals: widget.ghazals, poet: widget.poets),
                SherList(shers: widget.shers),
                NazamList(nazams: widget.nazams, poet: widget.poets),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
