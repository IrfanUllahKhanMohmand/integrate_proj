import 'package:flutter/material.dart';
import 'package:integration_test/model/sher.dart';
import 'package:integration_test/screens/PoetsList/widgets/tab_bar_sher_tile.dart';

class SherList extends StatefulWidget {
  const SherList({Key? key, required this.shers}) : super(key: key);
  final List<Sher> shers;
  @override
  State<SherList> createState() => _SherListState();
}

class _SherListState extends State<SherList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: widget.shers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
                  child: TabBarSherTile(sher: widget.shers[index]),
                );
              }),
        )
      ],
    );
  }
}
