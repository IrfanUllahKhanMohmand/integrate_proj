import 'package:flutter/material.dart';
import 'package:integration_test/screens/PoetsList/widgets/poetsListTile.dart';

class WomenPoetsList extends StatelessWidget {
  WomenPoetsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 500,
          child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return PoetsListTile(
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
