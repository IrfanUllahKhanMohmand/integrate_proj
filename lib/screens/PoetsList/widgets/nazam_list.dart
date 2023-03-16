import 'package:flutter/material.dart';
import 'package:integration_test/model/nazam.dart';
import 'package:integration_test/model/poet.dart';
import 'package:integration_test/screens/PoetsList/widgets/tab_nazam_tile.dart';
import 'package:integration_test/utils/constants.dart';
import 'package:integration_test/utils/on_generate_routes.dart';

class NazamList extends StatefulWidget {
  const NazamList({Key? key, required this.nazams, required this.poet})
      : super(key: key);
  final List<Nazam> nazams;
  final List<Poet> poet;
  @override
  State<NazamList> createState() => _NazamListState();
}

class _NazamListState extends State<NazamList> {
  getPoet(int id) {
    var poet = widget.poet.where((element) => element.id == id);
    return poet.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                          nazam: widget.nazams[index],
                          poet: getPoet(widget.nazams[index].poetId)),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6),
                    child: TabNazamTile(nazam: widget.nazams[index]),
                  ),
                );
              }),
        )
      ],
    );
  }
}
