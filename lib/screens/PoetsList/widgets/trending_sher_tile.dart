import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TrendingSherTile extends StatelessWidget {
  const TrendingSherTile({Key? key}) : super(key: key);
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
                // Text(sher.content.split('\n')[0]),
                // Text(sher.content.split('\n')[1])
                Text('کتنے عیش سے رہتے ہوں گے کتنے اتراتے ہوں گے'),
                Text('جانے کیسے لوگ وہ ہوں گے جو اس کو بھاتے ہوں گے'),
              ],
            ),
          ]),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SvgPicture.asset(
                    "assets/leftArrow.svg",
                    width: 10,
                    height: 10,
                  ),
                  SvgPicture.asset(
                    "assets/favourite.svg",
                    width: 10,
                    height: 10,
                  ),
                  SvgPicture.asset(
                    "assets/share.svg",
                    width: 10,
                    height: 10,
                  ),
                  SvgPicture.asset(
                    "assets/picture.svg",
                    width: 10,
                    height: 10,
                  ),
                  SvgPicture.asset(
                    "assets/videoCamera.svg",
                    width: 10,
                    height: 10,
                  ),
                  SvgPicture.asset(
                    "assets/rightArrow.svg",
                    width: 10,
                    height: 10,
                  ),
                ]),
          )
        ],
      ),
    );
  }
}
