import 'package:flutter/material.dart';
import 'package:integration_test/screens/PoetsList/widgets/poetsListTile.dart';

class TopReadPoetsList extends StatelessWidget {
  TopReadPoetsList({Key? key}) : super(key: key);
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
              itemCount: 20,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 4.0, mainAxisSpacing: 4, crossAxisCount: 3),
              itemBuilder: (context, index) {
                return const PoetsListTile(
                  imageUrl:
                      'https://rekhta.pc.cdn.bitgravity.com/Images/Shayar/ahmad-faraz.png',
                  realName: 'Ahmad Faraz',
                  noOfGhazals: 11,
                  noOfNazams: 8,
                  noOfSher: 7,
                );
              }),
        )
      ],
    );
  }
}
