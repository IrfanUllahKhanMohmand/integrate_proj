import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          padding: const EdgeInsets.all(6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: SvgPicture.asset(
                    "assets/left_arrow.svg",
                    width: 8,
                    height: 14,
                  ),
                ),
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/favourite.svg",
                    width: 8,
                    height: 14,
                  ),
                  const SizedBox(width: 15),
                  SvgPicture.asset(
                    "assets/share.svg",
                    width: 8,
                    height: 14,
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ],
          ),
        ),
        CachedNetworkImage(
          imageBuilder: (context, imageProvider) {
            return CircleAvatar(
              radius: 60,
              backgroundImage: imageProvider,
            );
          },
          imageUrl: imageUrl,
          placeholder: (context, url) => const Padding(
            padding: EdgeInsets.all(18.0),
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        // const CircleAvatar(
        // radius: 60,  // Image radius
        // backgroundImage: NetworkImage(
        //     'https://rekhta.pc.cdn.bitgravity.com/Images/Shayar/ahmad-faraz.png'),
        // ),
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
              '${yearOfBirth.substring(yearOfBirth.length - 4)}-${yearOfDeath.substring(yearOfDeath.length - 4)}',
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
