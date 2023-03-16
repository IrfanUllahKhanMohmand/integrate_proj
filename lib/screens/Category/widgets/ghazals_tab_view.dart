import 'package:flutter/material.dart';
import 'package:integration_test/model/poet.dart';
import 'package:integration_test/screens/Profile/widgets/ghazal_tile.dart';
import 'package:integration_test/utils/constants.dart';
import 'package:integration_test/utils/on_generate_routes.dart';

class GhazalsTabView extends StatelessWidget {
  const GhazalsTabView({super.key, required this.ghazals, required this.poet});
  final List ghazals;
  final Poet poet;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("GHAZAL",
                  style: TextStyle(color: Color.fromRGBO(93, 86, 250, 1))),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: ghazals.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ghazalPreview,
                      arguments: GhazalPreviewArguments(
                          ghazal: ghazals[index], poet: poet),
                    );
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: GhazalTile(
                          ghazal: ghazals[index],
                        ),
                      )
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }
}
