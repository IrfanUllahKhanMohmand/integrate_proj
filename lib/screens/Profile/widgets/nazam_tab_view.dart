import 'package:flutter/material.dart';
import 'package:integration_test/model/poet.dart';
import 'package:integration_test/screens/Profile/widgets/nazam_tile.dart';
import 'package:integration_test/utils/constants.dart';
import 'package:integration_test/utils/on_generate_routes.dart';

class NazamsTabView extends StatefulWidget {
  const NazamsTabView({super.key, required this.nazams, required this.poet});
  final List nazams;
  final Poet poet;
  @override
  State<NazamsTabView> createState() => _NazamsTabViewState();
}

class _NazamsTabViewState extends State<NazamsTabView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("NAZAM",
                  style: TextStyle(color: Color.fromRGBO(93, 86, 250, 1))),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: widget.nazams.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      nazamPreview,
                      arguments: NazamPreviewArguments(
                          nazam: widget.nazams[index], poet: widget.poet),
                    );
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: NazamTile(
                          nazam: widget.nazams[index],
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
