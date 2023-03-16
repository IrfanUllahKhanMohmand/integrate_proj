import 'package:flutter/material.dart';
import 'package:integration_test/model/poet.dart';
import 'package:integration_test/screens/PoetsList/widgets/poets_list_tile.dart';

class TopReadPoetsList extends StatefulWidget {
  const TopReadPoetsList({Key? key, required this.poets}) : super(key: key);
  final List<Poet> poets;
  @override
  State<TopReadPoetsList> createState() => _TopReadPoetsListState();
}

class _TopReadPoetsListState extends State<TopReadPoetsList> {
  final TextEditingController _textEditingController = TextEditingController();

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
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: GridView.builder(
              shrinkWrap: true,
              primary: false,
              physics: const ScrollPhysics(),
              itemCount: widget.poets.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 4.0, mainAxisSpacing: 4, crossAxisCount: 3),
              itemBuilder: (context, index) {
                return PoetsListTile(
                  imageUrl: widget.poets[index].pic,
                  realName: widget.poets[index].name,
                );
              }),
        )
      ],
    );
  }
}
