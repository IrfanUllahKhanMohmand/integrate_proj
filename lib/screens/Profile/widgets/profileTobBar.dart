import 'package:flutter/material.dart';

class ProfileTobBar extends StatelessWidget {
  const ProfileTobBar(
      {Key? key,
      required this.imageUrl,
      required this.fullName,
      required this.yearOfBirth,
      required this.birthPlace,
      required this.yearOfDeath})
      : super(key: key);

  final String imageUrl;
  final String fullName;
  final String yearOfBirth;
  final String yearOfDeath;
  final String birthPlace;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                color: const Color(0xff7c94b6),
                image: DecorationImage(
                  // image: AssetImage('assets/ahmad-faraz.png'),
                  image: NetworkImage(imageUrl),
                  // image: NetworkImage(
                  //     'https://rekhta.pc.cdn.bitgravity.com/Images/Shayar/ahmad-faraz.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                border: Border.all(
                  color: Colors.grey,
                  width: 4.0,
                ),
              ),
            ),
            SizedBox(
              width: 150,
              child: Text(
                fullName,
                style: const TextStyle(fontSize: 25, color: Colors.white),
                textAlign: TextAlign.justify,
              ),
            ),
            const Icon(
              Icons.favorite_outline,
              color: Colors.white,
            ),
            const Icon(Icons.share, color: Colors.white)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 60),
            Text(
              '$yearOfBirth-$yearOfDeath',
              style: const TextStyle(fontSize: 11, color: Colors.white),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(width: 3),
            const Text(
              '|',
              style: TextStyle(fontSize: 11, color: Colors.white),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(width: 3),
            Text(
              birthPlace,
              style: const TextStyle(fontSize: 11, color: Colors.white),
              textAlign: TextAlign.justify,
            ),
          ],
        )
      ],
    );
  }
}
