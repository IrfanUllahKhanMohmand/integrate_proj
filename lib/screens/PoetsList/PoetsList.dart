import 'package:flutter/material.dart';
import 'package:integration_test/screens/PoetsList/widgets/topBarTabs.dart';

class PoetsList extends StatelessWidget {
  const PoetsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // appBar: AppBar(
      //   backgroundColor: const Color.fromRGBO(93, 86, 250, 1),
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       const SizedBox(width: 4),
      //       // GestureDetector(
      //       //     onTap: () {
      //       //       // Navigator.pop(context);
      //       //     },
      //       //     child: const Icon(Icons.arrow_back)),
      //       const Text(
      //         'Nawees',
      //         style: TextStyle(),
      //       ),
      //       Row(
      //         children: const [
      //           Icon(Icons.search),
      //           SizedBox(width: 15),
      //           Icon(Icons.more_vert)
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width * .80,
              height: MediaQuery.of(context).size.height * .20,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border:
                      Border.all(color: const Color.fromRGBO(93, 86, 250, 1))),
            ),
            const TopBarTabs()
          ],
        ),
      ),
    );
  }
}
