import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:integration_test/Providers/catnazams_likes_provider.dart';
import 'package:integration_test/Providers/user_provider.dart';
import 'package:integration_test/model/category.dart';
import 'package:integration_test/screens/Category/widgets/cat_nazam_tile.dart';
import 'package:integration_test/utils/constants.dart';
import 'package:integration_test/utils/on_generate_routes.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryNazamsTabView extends StatefulWidget {
  const CategoryNazamsTabView(
      {super.key, required this.nazams, required this.category});
  final List nazams;
  final Category category;
  @override
  State<CategoryNazamsTabView> createState() => _CategoryNazamsTabViewState();
}

class _CategoryNazamsTabViewState extends State<CategoryNazamsTabView> {
  DefaultCacheManager cacheManager = DefaultCacheManager();

  Map<String, dynamic> nazamsData = {};

  getNazamsLikes() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final nazamProvider =
        Provider.of<CatNazamLikesProvider>(context, listen: false);

    for (var element in widget.nazams) {
      String cacheKey = 'catnazam_likes_${userProvider.userId}_${element.id}';
      FileInfo? cachedFile = await cacheManager.getFileFromCache(cacheKey);

      if (cachedFile != null) {
        // Likes data exists in the cache, read and parse it
        final String cachedData = await cachedFile.file.readAsString();
        var nazamLikes = jsonDecode(cachedData)['likes'];
        nazamProvider.add({element.id: nazamLikes});
      } else {
        // Likes data not found in the cache, fetch it from the API
        var response = await http.get(
          Uri.parse(
              'http://nawees.com/api/nazamlikes?user_id=${userProvider.userId}&catnazam_id=${element.id}'),
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $apiKey",
          },
        );
        if (response.statusCode == 200) {
          var nazamLikes = jsonDecode(response.body).values.first;
          nazamProvider.add({element.id: nazamLikes});

          // Cache the fetched data
          String jsonData = jsonEncode({'likes': nazamLikes});
          final Uint8List bytes = Uint8List.fromList(utf8.encode(jsonData));
          await cacheManager.putFile(cacheKey, bytes);
        }
      }
    }

    setState(() {});
    return nazamProvider.likes;
  }

  // Map nazamsData = {};

  // getNazamsLikes() async {
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);
  //   final catnazamProvider =
  //       Provider.of<CatNazamLikesProvider>(context, listen: false);
  //   for (var element in widget.nazams) {
  //     var response = await http.get(
  //       Uri.parse(
  //           'http://nawees.com/api/catnazamlikes?user_id=${userProvider.userId}&catnazam_id=${element.id}'),
  //       headers: {
  //         HttpHeaders.authorizationHeader: "Bearer $apiKey",
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       nazamsData = await jsonDecode(response.body);
  //       catnazamProvider.add({element.id: nazamsData.values.first});
  //       setState(() {});
  //     }
  //   }

  //   return catnazamProvider.likes;
  // }

  late final Future nazamsFuture = getNazamsLikes();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([nazamsFuture]),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        Widget children;
        if (snapshot.hasData) {
          children =
              Consumer<CatNazamLikesProvider>(builder: (context, nazam, child) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("NAZAM",
                          style:
                              TextStyle(color: Color.fromRGBO(93, 86, 250, 1))),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: widget.nazams.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              categoryNazamPreview,
                              arguments: CategoryNazamPreviewArguments(
                                  nazam: widget.nazams[index],
                                  cat: widget.category),
                            );
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: CatNazamTile(
                                  nazam: widget.nazams[index],
                                  isLiked:
                                      nazam.likes[widget.nazams[index].id] != 0,
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ],
            );
          });
        } else if (snapshot.hasError) {
          children =
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            ),
          ]);
        } else {
          children =
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(AppLocalizations.of(context)!.awaiting_result),
            ),
          ]);
        }
        return Center(
          child: children,
        );
      },
    );
  }
}
