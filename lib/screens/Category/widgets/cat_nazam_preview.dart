import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:integration_test/Providers/catnazams_likes_provider.dart';
import 'package:integration_test/Providers/local_provider.dart';
import 'package:integration_test/Providers/user_provider.dart';
import 'package:integration_test/model/category.dart';
import 'package:integration_test/model/nazam.dart';
import 'package:integration_test/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryNazamPreview extends StatefulWidget {
  const CategoryNazamPreview(
      {super.key, required this.nazam, required this.cat});
  final Nazam nazam;
  final Category cat;

  @override
  State<CategoryNazamPreview> createState() => _CategoryNazamPreviewState();
}

class _CategoryNazamPreviewState extends State<CategoryNazamPreview> {
  DefaultCacheManager cacheManager = DefaultCacheManager();
  likeNazam() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await http.post(
        Uri.parse('http://nawees.com/api/catnazamlikes'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer $apiKey",
        },
        body: jsonEncode(<String, dynamic>{
          "user_id": userProvider.userId,
          "catnazam_id": widget.nazam.id
        }));
    if (response.statusCode == 201) {
    } else {
      throw Exception('Failed to like nazam');
    }
  }

  dislikeNazam() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await http.delete(
        Uri.parse('http://nawees.com/api/catnazamlikes'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer $apiKey",
        },
        body: jsonEncode(<String, dynamic>{
          "user_id": userProvider.userId,
          "catnazam_id": widget.nazam.id
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
        child: Consumer<LocaleProvider>(builder: (context, value, child) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8),
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
                        value.locale!.languageCode == 'ur'
                            ? widget.nazam.title
                            : widget.nazam.romanTitle,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      value.locale!.languageCode == 'ur'
                          ? Text(widget.cat.nameUrd,
                              style: const TextStyle(
                                  color: Color.fromRGBO(93, 86, 250, 1),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500))
                          : Text(widget.cat.nameEng.toUpperCase(),
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
                        if (value.locale!.languageCode == 'ur') {
                          await copyToClipBoard(widget.nazam.content);
                        } else {
                          await copyToClipBoard(widget.nazam.romanContent);
                        }
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
                            children: [
                              const Icon(
                                Icons.video_camera_back_outlined,
                                size: 20,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                AppLocalizations.of(context)!.make_video_nazam,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 8),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Consumer<CatNazamLikesProvider>(
                      builder: (context, nazamProvider, child) {
                        return Row(
                          children: [
                            nazamProvider.likes[widget.nazam.id] != 0
                                ? InkWell(
                                    onTap: () async {
                                      Provider.of<CatNazamLikesProvider>(
                                              context,
                                              listen: false)
                                          .add({widget.nazam.id: 0});
                                      String cacheKey =
                                          'catnazam_likes_${Provider.of<UserProvider>(context, listen: false).userId}_${widget.nazam.id}';
                                      String jsonData =
                                          jsonEncode({'likes': 0});
                                      final Uint8List bytes =
                                          Uint8List.fromList(
                                              utf8.encode(jsonData));
                                      await cacheManager.putFile(
                                          cacheKey, bytes);
                                      await dislikeNazam();
                                    },
                                    child: const Icon(Icons.favorite,
                                        color: Colors.red, size: 15))
                                : InkWell(
                                    onTap: () async {
                                      Provider.of<CatNazamLikesProvider>(
                                              context,
                                              listen: false)
                                          .add({widget.nazam.id: 1});
                                      String cacheKey =
                                          'catnazam_likes_${Provider.of<UserProvider>(context, listen: false).userId}_${widget.nazam.id}';
                                      String jsonData =
                                          jsonEncode({'likes': 1});
                                      final Uint8List bytes =
                                          Uint8List.fromList(
                                              utf8.encode(jsonData));
                                      await cacheManager.putFile(
                                          cacheKey, bytes);
                                      await likeNazam();
                                    },
                                    child: const Icon(
                                        Icons.favorite_border_outlined,
                                        size: 15)),
                            const SizedBox(width: 10),
                            GestureDetector(
                                onTap: () {
                                  onShare(context, widget.nazam.content);
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
                      value.locale!.languageCode == 'ur'
                          ? widget.nazam.content
                          : widget.nazam.romanContent,
                      style: const TextStyle(color: Colors.black),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
