import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:integration_test/Providers/nazams_likes_provider.dart';
import 'package:integration_test/Providers/user_provider.dart';
import 'package:integration_test/model/poet.dart';
import 'package:integration_test/screens/PoetsList/widgets/tab_nazam_tile.dart';
import 'package:integration_test/utils/constants.dart';
import 'package:integration_test/utils/on_generate_routes.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NazamsTabView extends StatefulWidget {
  const NazamsTabView({super.key, required this.nazams, required this.poet});
  final List nazams;
  final Poet poet;

  @override
  State<NazamsTabView> createState() => _NazamsTabViewState();
}

class _NazamsTabViewState extends State<NazamsTabView> {
  DefaultCacheManager cacheManager = DefaultCacheManager();

  Map<String, dynamic> nazamsData = {};

  getNazamsLikes() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final nazamProvider =
        Provider.of<NazamLikesProvider>(context, listen: false);

    for (var element in widget.nazams) {
      String cacheKey = 'nazam_likes_${userProvider.userId}_${element.id}';
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
              'http://nawees.com/api/nazamlikes?user_id=${userProvider.userId}&nazam_id=${element.id}'),
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

  late final Future nazamsFuture = getNazamsLikes();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([nazamsFuture]),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        Widget children;
        if (snapshot.hasData) {
          children =
              Consumer<NazamLikesProvider>(builder: (context, nazam, child) {
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: widget.nazams.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              nazamPreview,
                              arguments: NazamPreviewArguments(
                                  nazam: widget.nazams[index],
                                  poet: widget.poet),
                            );
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: TabNazamTile(
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
