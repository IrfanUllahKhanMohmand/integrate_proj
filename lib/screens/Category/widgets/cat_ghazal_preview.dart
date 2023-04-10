import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:integration_test/Providers/catghazals_likes_provider.dart';
import 'package:integration_test/Providers/user_provider.dart';
import 'package:integration_test/model/category.dart';
import 'package:integration_test/model/ghazal.dart';

import 'package:http/http.dart' as http;
import 'package:integration_test/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class CategoryGhazalPreview extends StatefulWidget {
  const CategoryGhazalPreview(
      {super.key, required this.ghazal, required this.cat});
  final Ghazal ghazal;
  final Category cat;

  @override
  State<CategoryGhazalPreview> createState() => _CategoryGhazalPreviewState();
}

class _CategoryGhazalPreviewState extends State<CategoryGhazalPreview> {
  likeGhazal() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await http.post(
        Uri.parse('http://nawees.com/api/catghazallikes'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer $apiKey",
        },
        body: jsonEncode(<String, dynamic>{
          "user_id": userProvider.userId,
          "catghazal_id": widget.ghazal.id
        }));
    if (response.statusCode == 201) {
    } else {
      throw Exception('Failed to like nazam');
    }
  }

  dislikeGhazal() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await http.delete(
        Uri.parse('http://nawees.com/api/catghazallikes'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer $apiKey",
        },
        body: jsonEncode(<String, dynamic>{
          "user_id": userProvider.userId,
          "catghazal_id": widget.ghazal.id
        }));
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to unlike nazam');
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
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Icon(
                        Icons.arrow_back_ios,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.ghazal.content.split('\n')[0],
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(widget.cat.nameEng.toUpperCase(),
                        style: const TextStyle(
                            color: Color.fromRGBO(93, 86, 250, 1),
                            fontSize: 12,
                            fontWeight: FontWeight.w500)),
                    const Divider(
                      color: Colors.black,
                      thickness: 0.2,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 30),
                  GestureDetector(
                    onTap: () async {
                      await copyToClipBoard(widget.ghazal.content);
                      Navigator.pushNamed(context, projectEdit);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          gradient: const LinearGradient(colors: [
                            Color.fromRGBO(37, 28, 216, 1),
                            Color.fromRGBO(121, 115, 248, 1)
                          ]),
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.video_camera_back_outlined,
                              size: 20,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Make Video of this Ghazal',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 8),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Consumer<CatGhazalLikesProvider>(
                    builder: (context, ghazalProvider, child) {
                      return Row(
                        children: [
                          ghazalProvider.likes[widget.ghazal.id] != 0
                              ? InkWell(
                                  onTap: () async {
                                    Provider.of<CatGhazalLikesProvider>(context,
                                            listen: false)
                                        .add({widget.ghazal.id: 0});
                                    await dislikeGhazal();
                                  },
                                  child: const Icon(Icons.favorite,
                                      color: Colors.red, size: 15))
                              : InkWell(
                                  onTap: () async {
                                    Provider.of<CatGhazalLikesProvider>(context,
                                            listen: false)
                                        .add({widget.ghazal.id: 1});
                                    await likeGhazal();
                                  },
                                  child: const Icon(
                                      Icons.favorite_border_outlined,
                                      size: 15)),
                          const SizedBox(width: 10),
                          GestureDetector(
                              onTap: () {
                                onShare(context, widget.ghazal.content);
                              },
                              child: const Icon(Icons.share, size: 15)),
                          const SizedBox(width: 10),
                        ],
                      );
                    },
                  )
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    widget.ghazal.content,
                    style: const TextStyle(color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
