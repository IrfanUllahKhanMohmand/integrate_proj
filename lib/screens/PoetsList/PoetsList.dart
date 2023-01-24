import 'package:flutter/material.dart';
import 'package:integration_test/screens/PoetsList/widgets/topBarTabs.dart';

class PoetsList extends StatelessWidget {
  const PoetsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
                onTap: () {
                  // Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back)),
            const Text(
              'rekhta',
              style: TextStyle(),
            ),
            Row(
              children: const [
                Icon(Icons.search),
                SizedBox(width: 15),
                Icon(Icons.more_vert)
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [TopBarTabs()],
      ),
    );
  }
}
