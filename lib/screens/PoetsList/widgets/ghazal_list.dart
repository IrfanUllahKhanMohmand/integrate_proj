import 'package:flutter/material.dart';
import 'package:integration_test/screens/PoetsList/widgets/tab_bar_sher_tile.dart';

class GhazalList extends StatelessWidget {
  const GhazalList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
                  child: TabBarSherTile(),
                );
              }),
        )
      ],
    );
  }
}
