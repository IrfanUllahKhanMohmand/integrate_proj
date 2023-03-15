import 'package:flutter/material.dart';
import 'package:integration_test/screens/Profile/widgets/nazam_tile.dart';
import 'package:integration_test/utils/constants.dart';

class GhazalsTabView extends StatelessWidget {
  const GhazalsTabView({super.key});

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
              itemCount: 20,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      nazamPreview,
                    );
                  },
                  child: Column(
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        // child: NazamTile(),
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
