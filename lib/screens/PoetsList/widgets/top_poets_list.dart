import 'package:flutter/material.dart';
import 'package:integration_test/model/poet.dart';
import 'package:integration_test/screens/PoetsList/widgets/poets_list_tile.dart';
import 'package:integration_test/utils/constants.dart';
import 'package:integration_test/utils/on_generate_routes.dart';

class TopReadPoetsList extends StatefulWidget {
  const TopReadPoetsList({Key? key, required this.poets}) : super(key: key);
  final List<Poet> poets;
  @override
  State<TopReadPoetsList> createState() => _TopReadPoetsListState();
}

class _TopReadPoetsListState extends State<TopReadPoetsList> {
  final TextEditingController _textEditingController = TextEditingController();
  List<Poet> searchResult = [];
  onSearchTextChanged(String text) async {
    searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (var poet in widget.poets) {
      if (poet.nameEng.toLowerCase().contains(text)) {
        searchResult.add(poet);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: SizedBox(
            height: 40,
            child: TextFormField(
              controller: _textEditingController,
              onChanged: onSearchTextChanged,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: searchResult.isNotEmpty ||
                  _textEditingController.text.isNotEmpty
              ? GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  physics: const ScrollPhysics(),
                  itemCount: searchResult.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4,
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          authorProfile,
                          arguments: PoetScreenArguments(
                            id: searchResult[index].id,
                          ),
                        );
                      },
                      child: PoetsListTile(
                        poet: searchResult[index],
                      ),
                    );
                  })
              : GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  physics: const ScrollPhysics(),
                  itemCount: widget.poets.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4,
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          authorProfile,
                          arguments: PoetScreenArguments(
                            id: widget.poets[index].id,
                          ),
                        );
                      },
                      child: PoetsListTile(
                        poet: widget.poets[index],
                      ),
                    );
                  }),
        )
      ],
    );
  }
}
