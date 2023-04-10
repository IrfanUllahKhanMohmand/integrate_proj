import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:integration_test/Providers/local_provider.dart';
import 'package:integration_test/model/category.dart';
import 'package:provider/provider.dart';

class CategoriesListTile extends StatelessWidget {
  const CategoriesListTile({Key? key, required this.category})
      : super(key: key);
  final Category category;

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
            imageUrl: category.pic,
            placeholder: (context, url) => const Padding(
              padding: EdgeInsets.all(18.0),
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        Consumer<LocaleProvider>(
          builder: (context, value, child) {
            return Text(
              value.locale!.languageCode == 'ur'
                  ? category.nameUrd
                  : category.nameEng,
              style: const TextStyle(
                  fontSize: 10, color: Color.fromRGBO(151, 151, 151, 1)),
            );
          },
        )
      ],
    );
  }
}
