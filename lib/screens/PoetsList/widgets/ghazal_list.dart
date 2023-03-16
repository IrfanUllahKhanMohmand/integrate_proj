import 'package:flutter/material.dart';
import 'package:integration_test/model/ghazal.dart';
import 'package:integration_test/model/poet.dart';
import 'package:integration_test/screens/PoetsList/widgets/tab_ghazal_tile.dart';
import 'package:integration_test/utils/constants.dart';
import 'package:integration_test/utils/on_generate_routes.dart';

class GhazalList extends StatefulWidget {
  const GhazalList({Key? key, required this.ghazals, required this.poet})
      : super(key: key);
  final List<Ghazal> ghazals;
  final List<Poet> poet;
  @override
  State<GhazalList> createState() => _GhazalListState();
}

class _GhazalListState extends State<GhazalList> {
  getPoet(int id) {
    var poet = widget.poet.where((element) => element.id == id);
    return poet.first;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: widget.ghazals.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ghazalPreview,
                      arguments: GhazalPreviewArguments(
                          ghazal: widget.ghazals[index],
                          poet: getPoet(widget.ghazals[index].poetId)),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6),
                    child: TabGhazalTile(
                      ghazal: widget.ghazals[index],
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }
}
