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
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
              Row(
                children: const [
                  Icon(
                    Icons.favorite_outline,
                    color: Colors.black,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.share,
                    color: Colors.black,
                    size: 20,
                  )
                ],
              ),
            ],
          ),
        ),
        const CircleAvatar(
          radius: 60, // Image radius
          backgroundImage: NetworkImage(
              'https://rekhta.pc.cdn.bitgravity.com/Images/Shayar/ahmad-faraz.png'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              fullName,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              birthPlace,
              style: const TextStyle(fontSize: 8, color: Colors.black),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(width: 3),
            const Text(
              '|',
              style: TextStyle(fontSize: 8, color: Colors.black),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(width: 3),
            Text(
              '$yearOfBirth-$yearOfDeath',
              style: const TextStyle(fontSize: 8, color: Colors.black),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
        const SizedBox(height: 5)
      ],
    );
  }
}
