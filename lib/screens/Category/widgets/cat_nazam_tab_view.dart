import 'package:flutter/material.dart';
import 'package:integration_test/model/category.dart';
import 'package:integration_test/screens/Profile/widgets/nazam_tile.dart';
import 'package:integration_test/utils/constants.dart';
import 'package:integration_test/utils/on_generate_routes.dart';

class CategoryNazamsTabView extends StatefulWidget {
  const CategoryNazamsTabView(
      {super.key, required this.nazams, required this.category});
  final List nazams;
  final Category category;
  @override
  State<CategoryNazamsTabView> createState() => _CategoryNazamsTabViewState();
}

class _CategoryNazamsTabViewState extends State<CategoryNazamsTabView> {
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
                      categoryNazamPreview,
                      arguments: CategoryNazamPreviewArguments(
                          nazam: widget.nazams[index], cat: widget.category),
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
