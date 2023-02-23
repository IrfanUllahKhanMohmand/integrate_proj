import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NazamTile extends StatelessWidget {
  const NazamTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .95,
      height: 82.0,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0xffDDDDDD),
            blurRadius: 6.0,
            spreadRadius: 2.0,
            offset: Offset(0.0, 0.0),
          )
        ],
        border:
            Border.all(width: 2, color: const Color.fromRGBO(112, 112, 112, 0)),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: const [
                Text('کتنے عیش سے رہتے ہوں گے کتنے اتراتے ہوں گے'),
                Text('جانے کیسے لوگ وہ ہوں گے جو اس کو بھاتے ہوں گے'),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SvgPicture.asset(
                "assets/favourite.svg",
                width: 16,
                height: 16,
              ),
            )
          ]),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
