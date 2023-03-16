import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryProfileTobBar extends StatelessWidget {
  const CategoryProfileTobBar({
    Key? key,
    required this.id,
    required this.name,
    required this.description,
    required this.pic,
  }) : super(key: key);

  final int id;
  final String name;
  final String description;
  final String pic;

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
          imageUrl: pic,
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
              name,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.justify,
            ),
          ],
        ),

        const SizedBox(height: 5)
      ],
    );
  }
}
