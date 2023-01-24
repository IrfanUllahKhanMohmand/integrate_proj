import 'package:flutter/material.dart';
import 'package:integration_test/screens/PoetsList/widgets/poetsListTile.dart';
import 'package:integration_test/utils/constants.dart';

class AllPoetsList extends StatelessWidget {
  AllPoetsList({Key? key}) : super(key: key);
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: SizedBox(
              height: 40,
              child: TextFormField(
                controller: _textEditingController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder()),
              ),
            ),
          ),
          SizedBox(
            height: 500,
            child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, authorProfile);
                    },
                    child: AbsorbPointer(
                      child: PoetsListTile(
                        imageUrl:
                            'https://rekhta.pc.cdn.bitgravity.com/Images/Shayar/ahmad-faraz.png',
                        realName: 'Ahmad Faraz',
                        noOfGhazals: 11,
                        noOfNazams: 8,
                        noOfSher: 7,
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
