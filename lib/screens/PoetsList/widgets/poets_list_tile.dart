import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PoetsListTile extends StatelessWidget {
  const PoetsListTile(
      {Key? key, required this.realName, required this.imageUrl})
      : super(key: key);
  final String realName;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 82.0,
          height: 82.0,
          // child: Image.network(imageUrl),
          child: CachedNetworkImage(
            imageBuilder: (context, imageProvider) {
              return Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      width: 1.0, color: const Color.fromRGBO(93, 86, 250, 1)),
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              );
            },
            imageUrl: imageUrl,
            placeholder: (context, url) => const Padding(
              padding: EdgeInsets.all(18.0),
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
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
