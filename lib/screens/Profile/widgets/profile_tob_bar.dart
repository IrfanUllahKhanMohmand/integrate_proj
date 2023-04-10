import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:http/http.dart' as http;
import 'package:integration_test/Providers/local_provider.dart';
import 'package:integration_test/Providers/poets_likes_provider.dart';
import 'package:integration_test/Providers/user_provider.dart';
import 'package:integration_test/model/poet.dart';
import 'package:integration_test/utils/constants.dart';
import 'package:provider/provider.dart';

class ProfileTobBar extends StatefulWidget {
  const ProfileTobBar({Key? key, required this.poet}) : super(key: key);

  final Poet poet;

  @override
  State<ProfileTobBar> createState() => _ProfileTobBarState();
}

class _ProfileTobBarState extends State<ProfileTobBar> {
  likeSher() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await http.post(
        Uri.parse('http://nawees.com/api/poetlikes'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer $apiKey",
        },
        body: jsonEncode(<String, dynamic>{
          "user_id": userProvider.userId,
          "poet_id": widget.poet.id
        }));
    if (response.statusCode == 201) {
    } else {
      throw Exception('Failed to like sher');
    }
  }

  dislikeSher() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await http.delete(
        Uri.parse('http://nawees.com/api/poetlikes'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer $apiKey",
        },
        body: jsonEncode(<String, dynamic>{
          "user_id": userProvider.userId,
          "poet_id": widget.poet.id
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
                  child: SvgPicture.asset(
                    "assets/left_arrow.svg",
                    width: 8,
                    height: 14,
                  ),
                ),
              ),
              Row(
                children: [
                  Consumer<PoetLikesProvider>(
                    builder: (context, poetProvider, child) {
                      return poetProvider.likes[widget.poet.id] != 0
                          ? InkWell(
                              onTap: () async {
                                Provider.of<PoetLikesProvider>(context,
                                        listen: false)
                                    .add({widget.poet.id: 0});
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
                                Provider.of<PoetLikesProvider>(context,
                                        listen: false)
                                    .add({widget.poet.id: 1});
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
          imageUrl: widget.poet.pic,
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
        Consumer<LocaleProvider>(
          builder: (context, value, child) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      value.locale!.languageCode == 'ur'
                          ? widget.poet.nameUrd
                          : widget.poet.nameEng,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      value.locale!.languageCode == 'ur'
                          ? widget.poet.birthCityUrd
                          : widget.poet.birthCityEng,
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
                    widget.poet.alive == 0
                        ? Text(
                            '${widget.poet.birthDate.substring(widget.poet.birthDate.length - 4)}-${widget.poet.deathDate.substring(widget.poet.deathDate.length - 4)}',
                            style: const TextStyle(
                                fontSize: 8, color: Colors.black),
                            textAlign: TextAlign.justify,
                          )
                        : Text(
                            widget.poet.birthDate
                                .substring(widget.poet.birthDate.length - 4),
                            style: const TextStyle(
                                fontSize: 8, color: Colors.black),
                            textAlign: TextAlign.justify,
                          ),
                  ],
                )
              ],
            );
          },
        ),

        const SizedBox(height: 5)
      ],
    );
  }
}
