import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:http/http.dart' as http;
import 'package:integration_test/Providers/category_likes_provider.dart';
import 'package:integration_test/Providers/local_provider.dart';
import 'package:integration_test/Providers/user_provider.dart';
import 'package:integration_test/model/category.dart';
import 'package:integration_test/utils/constants.dart';
import 'package:provider/provider.dart';

class CategoryProfileTobBar extends StatefulWidget {
  const CategoryProfileTobBar({Key? key, required this.cat}) : super(key: key);

  final Category cat;

  @override
  State<CategoryProfileTobBar> createState() => _CategoryProfileTobBarState();
}

class _CategoryProfileTobBarState extends State<CategoryProfileTobBar> {
  likeSher() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await http.post(
        Uri.parse('http://nawees.com/api/categorylikes'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer $apiKey",
        },
        body: jsonEncode(<String, dynamic>{
          "user_id": userProvider.userId,
          "category_id": widget.cat.id
        }));
    if (response.statusCode == 201) {
    } else {
      throw Exception('Failed to like sher');
    }
  }

  dislikeSher() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await http.delete(
        Uri.parse('http://nawees.com/api/categorylikes'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer $apiKey",
        },
        body: jsonEncode(<String, dynamic>{
          "user_id": userProvider.userId,
          "category_id": widget.cat.id
        }));
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to unlike sher');
    }
  }

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
                  child: Localizations.localeOf(context).languageCode == 'ur'
                      ? SvgPicture.asset(
                          "assets/rightArrow.svg",
                          width: 8,
                          height: 14,
                        )
                      : SvgPicture.asset(
                          "assets/left_arrow.svg",
                          width: 8,
                          height: 14,
                        ),
                ),
              ),
              Row(
                children: [
                  Consumer<CategoryLikesProvider>(
                    builder: (context, categoryProvider, child) {
                      return categoryProvider.likes[widget.cat.id] != null &&
                              categoryProvider.likes[widget.cat.id] != 0
                          ? InkWell(
                              onTap: () async {
                                Provider.of<CategoryLikesProvider>(context,
                                        listen: false)
                                    .add({widget.cat.id: 0});
                                await dislikeSher();
                              },
                              child: SvgPicture.asset(
                                "assets/favourite.svg",
                                width: 10,
                                height: 10,
                                // ignore: deprecated_member_use
                                color: Colors.red,
                              ))
                          : InkWell(
                              onTap: () async {
                                Provider.of<CategoryLikesProvider>(context,
                                        listen: false)
                                    .add({widget.cat.id: 1});
                                await likeSher();
                              },
                              child: SvgPicture.asset(
                                "assets/favourite.svg",
                                width: 10,
                                height: 10,
                              ),
                            );
                    },
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
          imageUrl: widget.cat.pic,
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
        Consumer<LocaleProvider>(builder: (context, value, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value.locale!.languageCode == 'ur'
                    ? widget.cat.nameUrd
                    : widget.cat.nameEng,
                style: const TextStyle(fontSize: 16, color: Colors.black),
                textAlign: TextAlign.justify,
              ),
            ],
          );
        }),

        const SizedBox(height: 5)
      ],
    );
  }
}
