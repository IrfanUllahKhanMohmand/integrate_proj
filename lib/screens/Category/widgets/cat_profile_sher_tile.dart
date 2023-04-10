import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:integration_test/Providers/catsher_likes_provider.dart';
import 'package:integration_test/Providers/user_provider.dart';
import 'package:integration_test/model/category.dart';
import 'package:integration_test/model/sher.dart';
import 'package:integration_test/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class CategoryProfileSherTile extends StatefulWidget {
  const CategoryProfileSherTile(
      {Key? key, required this.sher, required this.cat})
      : super(key: key);
  final Sher sher;
  final Category cat;

  @override
  State<CategoryProfileSherTile> createState() =>
      _CategoryProfileSherTileState();
}

class _CategoryProfileSherTileState extends State<CategoryProfileSherTile> {
  likeSher() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await http.post(
        Uri.parse('http://nawees.com/api/catsherlikes'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer $apiKey",
        },
        body: jsonEncode(<String, dynamic>{
          "user_id": userProvider.userId,
          "catsher_id": widget.sher.id
        }));
    if (response.statusCode == 201) {
    } else {
      throw Exception('Failed to like sher');
    }
  }

  dislikeSher() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await http.delete(
        Uri.parse('http://nawees.com/api/catsherlikes'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer $apiKey",
        },
        body: jsonEncode(<String, dynamic>{
          "user_id": userProvider.userId,
          "catsher_id": widget.sher.id
        }));
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to unlike sher');
    }
  }

  copyToClipBoard(String txt) async {
    await Clipboard.setData(ClipboardData(text: txt));
  }

  void onShare(BuildContext context, String txt) async {
    final box = context.findRenderObject() as RenderBox;
    await Share.share(txt,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

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
              children: [
                Text(widget.sher.content.split('\n')[0]),
                Text(widget.sher.content.split('\n')[1]),
                // Text('کتنے عیش سے رہتے ہوں گے کتنے اتراتے ہوں گے'),
                // Text('جانے کیسے لوگ وہ ہوں گے جو اس کو بھاتے ہوں گے'),
              ],
            ),
          ]),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () async {
                      await copyToClipBoard(widget.sher.content);

                      Navigator.pushNamed(context, projectEdit);
                    },
                    child: AbsorbPointer(
                      child: SvgPicture.asset(
                        "assets/videoCamera.svg",
                        width: 10,
                        height: 10,
                      ),
                    ),
                  ),
                  Consumer<CatSherLikesProvider>(
                    builder: (context, sherProvider, child) {
                      return sherProvider.likes[widget.sher.id] != 0
                          ? InkWell(
                              onTap: () async {
                                Provider.of<CatSherLikesProvider>(context,
                                        listen: false)
                                    .add({widget.sher.id: 0});
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
                                Provider.of<CatSherLikesProvider>(context,
                                        listen: false)
                                    .add({widget.sher.id: 1});
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
                  GestureDetector(
                    onTap: () {
                      onShare(context, widget.sher.content);
                    },
                    child: SvgPicture.asset(
                      "assets/share.svg",
                      width: 10,
                      height: 10,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await copyToClipBoard(widget.sher.content);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Copied to ClipBoard')));
                    },
                    child: SvgPicture.asset(
                      "assets/copy.svg",
                      width: 10,
                      height: 10,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await copyToClipBoard(widget.sher.content);
                      Navigator.pushNamed(context, storiesEditor);
                    },
                    child: SvgPicture.asset(
                      "assets/picture.svg",
                      width: 10,
                      height: 10,
                    ),
                  ),
                  const SizedBox(width: 10),
                ]),
          )
        ],
      ),
    );
  }
}
