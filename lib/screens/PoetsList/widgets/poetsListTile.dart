import 'package:flutter/material.dart';

class PoetsListTile extends StatelessWidget {
  const PoetsListTile(
      {Key? key,
      required this.realName,
      required this.imageUrl,
      required this.noOfGhazals,
      required this.noOfNazams,
      required this.noOfSher})
      : super(key: key);
  final String realName;
  final String imageUrl;
  final int noOfGhazals;
  final int noOfNazams;
  final int noOfSher;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 82.0,
          height: 82.0,
          decoration: BoxDecoration(
            color: const Color(0xff7c94b6),
            border: Border.all(color: const Color.fromRGBO(93, 86, 250, 1)),
            image: DecorationImage(
              // image: AssetImage('assets/ahmad-faraz.png'),
              image: NetworkImage(imageUrl),
              // image: NetworkImage(
              //     'https://rekhta.pc.cdn.bitgravity.com/Images/Shayar/ahmad-faraz.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
        ),
        Text(
          realName,
          style: const TextStyle(
              fontSize: 10, color: Color.fromRGBO(151, 151, 151, 1)),
        ),
      ],
    );
  }
}
