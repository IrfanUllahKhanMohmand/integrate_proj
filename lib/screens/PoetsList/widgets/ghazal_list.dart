import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:integration_test/Providers/ghazals_likes_provider.dart';
import 'package:integration_test/Providers/user_provider.dart';
import 'package:integration_test/model/ghazal.dart';
import 'package:integration_test/model/poet.dart';
import 'package:integration_test/screens/PoetsList/widgets/tab_ghazal_tile.dart';
import 'package:integration_test/utils/constants.dart';
import 'package:integration_test/utils/on_generate_routes.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GhazalList extends StatefulWidget {
  const GhazalList({Key? key, required this.ghazals, required this.poet})
      : super(key: key);
  final List<Ghazal> ghazals;
  final List<Poet> poet;
  @override
  State<GhazalList> createState() => _GhazalListState();
}

class _GhazalListState extends State<GhazalList> {
  DefaultCacheManager cacheManager = DefaultCacheManager();
  getPoet(int id) {
    var poet = widget.poet.where((element) => element.id == id);
    return poet.first;
  }

  Map<String, dynamic> ghazalsData = {};

  getGhazalsLikes() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final ghazalProvider =
        Provider.of<GhazalLikesProvider>(context, listen: false);

    for (var element in widget.ghazals) {
      String cacheKey = 'ghazal_likes_${userProvider.userId}_${element.id}';
      FileInfo? cachedFile = await cacheManager.getFileFromCache(cacheKey);

      if (cachedFile != null) {
        // Likes data exists in the cache, read and parse it
        final String cachedData = await cachedFile.file.readAsString();
        var ghazalLikes = jsonDecode(cachedData)['likes'];
        ghazalProvider.add({element.id: ghazalLikes});
      } else {
        // Likes data not found in the cache, fetch it from the API
        var response = await http.get(
          Uri.parse(
              'http://nawees.com/api/ghazallikes?user_id=${userProvider.userId}&ghazal_id=${element.id}'),
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $apiKey",
          },
        );
        if (response.statusCode == 200) {
          var ghazalLikes = jsonDecode(response.body).values.first;
          ghazalProvider.add({element.id: ghazalLikes});

          // Cache the fetched data
          String jsonData = jsonEncode({'likes': ghazalLikes});
          final Uint8List bytes = Uint8List.fromList(utf8.encode(jsonData));
          await cacheManager.putFile(cacheKey, bytes);
        }
      }
    }

    setState(() {});
    return ghazalProvider.likes;
  }

  late final Future ghazalsLikesFuture = getGhazalsLikes();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([ghazalsLikesFuture]),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        Widget children;
        if (snapshot.hasData) {
          children = Consumer<GhazalLikesProvider>(
              builder: (context, ghazalProv, child) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: widget.ghazals.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              ghazalPreview,
                              arguments: GhazalPreviewArguments(
                                  ghazal: widget.ghazals[index],
                                  poet: getPoet(widget.ghazals[index].poetId)),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6),
                            child: TabGhazalTile(
                                ghazal: widget.ghazals[index],
                                isLiked: ghazalProv
                                        .likes[widget.ghazals[index].id] !=
                                    0),
                          ),
                        );
                      }),
                )
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
