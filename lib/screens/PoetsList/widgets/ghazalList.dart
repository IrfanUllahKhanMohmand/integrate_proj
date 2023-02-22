import 'package:flutter/material.dart';
import 'package:integration_test/screens/PoetsList/widgets/poetsListTile.dart';
import 'package:integration_test/screens/PoetsList/widgets/sherTile.dart';
import 'package:integration_test/screens/PoetsList/widgets/tabBarSherTile.dart';

class GhazalList extends StatelessWidget {
  const GhazalList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .85,
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
