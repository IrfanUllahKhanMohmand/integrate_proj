import 'package:flutter/material.dart';

class ProfileSherTile extends StatelessWidget {
  const ProfileSherTile({
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
          ]),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.video_camera_back_rounded, size: 10),
                  SizedBox(width: 10),
                  Icon(Icons.favorite_outline_sharp, size: 10),
                  SizedBox(width: 10),
                  Icon(Icons.share, size: 10),
                  SizedBox(width: 10),
                  Icon(Icons.copy, size: 10),
                  SizedBox(width: 10),
                  Icon(Icons.image_outlined, size: 10),
                ]),
          )
        ],
      ),
    );
  }
}
