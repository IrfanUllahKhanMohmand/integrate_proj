import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:integration_test/Providers/category_likes_provider.dart';
import 'package:integration_test/Providers/poets_likes_provider.dart';
import 'package:integration_test/Providers/user_provider.dart';
import 'package:integration_test/model/category.dart';
import 'package:integration_test/model/poet.dart';
import 'package:integration_test/model/sher.dart';
import 'package:integration_test/screens/PoetsList/widgets/categories_list_tile.dart';
import 'package:integration_test/screens/PoetsList/widgets/poets_list_tile.dart';
import 'package:integration_test/screens/PoetsList/widgets/trending_sher_tile.dart';
import 'package:integration_test/utils/constants.dart';

import 'package:integration_test/utils/on_generate_routes.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllPoetsList extends StatefulWidget {
  const AllPoetsList(
      {Key? key,
      required this.poets,
      required this.categories,
      required this.trendingShers})
      : super(key: key);
  final List<Poet> poets;
  final List<Category> categories;
  final List trendingShers;

  @override
  State<AllPoetsList> createState() => _AllPoetsListState();
}

class _AllPoetsListState extends State<AllPoetsList> {
  DefaultCacheManager cacheManager = DefaultCacheManager();
  Map poetsData = {};
  Map categoriesData = {};
  List<Sher> trendShers = [];

  // getTrendingShers() async {
  //   for (var element in widget.trendingShers) {
  //     var response = await http.get(
  //       Uri.parse('http://nawees.com/api/shers/${element['sher_id']}'),
  //       headers: {
  //         HttpHeaders.authorizationHeader: "Bearer $apiKey",
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         Sher data = Sher.fromJson(jsonDecode(response.body));
  //         trendShers.add(data);
  //       });
  //     }
  //   }

  //   return trendShers;
  // }

  Future getTrendingShers() async {
    const String cacheKey = 'trending_shers_data_all';

    // Check if the response is already cached
    FileInfo? cachedFile = await cacheManager.getFileFromCache(cacheKey);
    if (cachedFile != null) {
      // Data exists in the cache, read and parse it
      final String cachedData = await cachedFile.file.readAsString();
      final List<dynamic> cachedShers = jsonDecode(cachedData);
      setState(() {
        trendShers = cachedShers.map((e) => Sher.fromJson(e)).toList();
      });
      return cachedShers.map((e) => Sher.fromJson(e)).toList();
    } else {
      // Data not found in the cache, fetch it from the API

      for (var element in widget.trendingShers) {
        var response = await http.get(
          Uri.parse('http://nawees.com/api/shers/${element['sher_id']}'),
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $apiKey",
          },
        );
        if (response.statusCode == 200) {
          Sher data = Sher.fromJson(jsonDecode(response.body));
          trendShers.add(data);
        }
      }

      // Cache the fetched data
      final Uint8List bytes = Uint8List.fromList(
          utf8.encode(jsonEncode(trendShers.map((e) => e.toJson()).toList())));
      await cacheManager.putFile(cacheKey, bytes);

      return trendShers;
    }
  }

  // Future getTrendingShers() async {
  //   const String cacheKey = 'ttrending_shers_data_all_poets_list';

  //   // Check if the response is already cached
  //   FileInfo? cachedFile = await cacheManager.getFileFromCache(cacheKey);
  //   if (cachedFile != null) {
  //     // Data exists in the cache, read and parse it
  //     final String cachedData = await cachedFile.file.readAsString();
  //     final List<dynamic> cachedShers = jsonDecode(cachedData);
  //     setState(() {
  //       print(cachedShers);
  //     });
  //     return cachedShers.map((e) => Sher.fromJson(e)).toList();
  //   } else {
  //     String res = '';
  //     // Data not found in the cache, fetch it from the API
  //     for (var element in widget.trendingShers) {
  //       var response = await http.get(
  //         Uri.parse('http://nawees.com/api/shers/${element['sher_id']}'),
  //         headers: {
  //           HttpHeaders.authorizationHeader: "Bearer $apiKey",
  //         },
  //       );
  //       if (response.statusCode == 200) {
  //         setState(() {
  //           Sher data = Sher.fromJson(jsonDecode(response.body));
  //           trendShers.add(data);

  //           res += response.body;
  //         });
  //       }
  //       final Uint8List bytes = Uint8List.fromList(utf8.encode(res));
  //       await cacheManager.putFile(cacheKey, bytes);
  //     }
  //   }
  // }

  Future getPoetsLikes() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final poetProvider = Provider.of<PoetLikesProvider>(context, listen: false);

    for (var element in widget.poets) {
      String cacheKey = 'poets_likes_${userProvider.userId}_${element.id}';
      FileInfo? cachedFile = await cacheManager.getFileFromCache(cacheKey);

      if (cachedFile != null) {
        // Likes data exists in the cache, read and parse it
        final String cachedData = await cachedFile.file.readAsString();
        var poetsLikes = jsonDecode(cachedData)['likes'];
        poetProvider.add({element.id: poetsLikes});
      } else {
        // Likes data not found in the cache, fetch it from the API
        var response = await http.get(
          Uri.parse(
              'http://nawees.com/api/poetlikes?user_id=${userProvider.userId}&poet_id=${element.id}'),
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $apiKey",
          },
        );
        if (response.statusCode == 200) {
          var poetsLikes = jsonDecode(response.body).values.first;
          poetProvider.add({element.id: poetsLikes});

          // Cache the fetched data
          String jsonData = jsonEncode({'likes': poetsLikes});
          final Uint8List bytes = Uint8List.fromList(utf8.encode(jsonData));
          await cacheManager.putFile(cacheKey, bytes);
        }
      }
    }

    setState(() {});
    return poetProvider.likes;
  }

  // getPoetsLikes() async {
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);
  //   final poetProvider = Provider.of<PoetLikesProvider>(context, listen: false);
  //   for (var element in widget.poets) {
  //     var response = await http.get(
  //       Uri.parse(
  //           'http://nawees.com/api/poetlikes?user_id=${userProvider.userId}&poet_id=${element.id}'),
  //       headers: {
  //         HttpHeaders.authorizationHeader: "Bearer $apiKey",
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       poetsData = await jsonDecode(response.body);
  //       poetProvider.add({element.id: poetsData.values.first});
  //       setState(() {});
  //     }
  //   }

  //   return poetProvider.likes;
  // }

  Future getCategoriesLikes() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final categoriesProvider =
        Provider.of<CategoryLikesProvider>(context, listen: false);

    for (var element in widget.categories) {
      String cacheKey = 'categories_likes_${userProvider.userId}_${element.id}';
      FileInfo? cachedFile = await cacheManager.getFileFromCache(cacheKey);

      if (cachedFile != null) {
        // Likes data exists in the cache, read and parse it
        final String cachedData = await cachedFile.file.readAsString();
        var categoriesLikes = jsonDecode(cachedData)['likes'];
        categoriesProvider.add({element.id: categoriesLikes});
      } else {
        // Likes data not found in the cache, fetch it from the API
        var response = await http.get(
          Uri.parse(
              'http://nawees.com/api/categorylikes?user_id=${userProvider.userId}&category_id=${element.id}'),
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $apiKey",
          },
        );
        if (response.statusCode == 200) {
          var categoriesLikes = jsonDecode(response.body).values.first;
          categoriesProvider.add({element.id: categoriesLikes});

          // Cache the fetched data
          String jsonData = jsonEncode({'likes': categoriesLikes});
          final Uint8List bytes = Uint8List.fromList(utf8.encode(jsonData));
          await cacheManager.putFile(cacheKey, bytes);
        }
      }
    }

    setState(() {});
    return categoriesProvider.likes;
  }

  // getCategoriesLikes() async {
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);
  //   final categoriesProvider =
  //       Provider.of<CategoryLikesProvider>(context, listen: false);
  //   for (var element in widget.poets) {
  //     var response = await http.get(
  //       Uri.parse(
  //           'http://nawees.com/api/categorylikes?user_id=${userProvider.userId}&category_id=${element.id}'),
  //       headers: {
  //         HttpHeaders.authorizationHeader: "Bearer $apiKey",
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       categoriesData = await jsonDecode(response.body);
  //       categoriesProvider.add({element.id: categoriesData.values.first});
  //       setState(() {});
  //     }
  //   }

  //   return categoriesProvider.likes;
  // }

  copyToClipBoard(String txt) async {
    await Clipboard.setData(ClipboardData(text: txt));
  }

  late Future poetsLikesFuture = getPoetsLikes();
  late Future categoriesLikesFuture = getCategoriesLikes();
  late Future trendingShersFuture = getTrendingShers();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        poetsLikesFuture,
        categoriesLikesFuture,
        trendingShersFuture,
      ]),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        Widget children;
        if (snapshot.hasData) {
          children = SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    InkWell(
                      onTap: () async {
                        await copyToClipBoard("");
                        Navigator.pushNamed(context, storiesEditor);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * .45,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            gradient: const LinearGradient(colors: [
                              Color.fromRGBO(37, 28, 216, 1),
                              Color.fromRGBO(37, 28, 216, 0.6),
                            ]),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                "assets/picture.svg",
                                width: 40,
                                height: 40,
                                colorFilter: const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                              ),
                              Text(
                                AppLocalizations.of(context)!.make_status,
                                style: const TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: () async {
                        await copyToClipBoard("");

                        Navigator.pushNamed(context, projectEdit);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * .45,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            gradient: const LinearGradient(colors: [
                              Color.fromRGBO(37, 28, 216, 1),
                              Color.fromRGBO(121, 115, 248, 1)
                            ]),
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                "assets/videoCamera.svg",
                                width: 40,
                                height: 40,
                                colorFilter: const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                              ),
                              Text(
                                AppLocalizations.of(context)!.make_video,
                                style: const TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
                Row(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      AppLocalizations.of(context)!.most_read_poets,
                      style: const TextStyle(
                          fontSize: 12, color: Color.fromRGBO(93, 86, 250, 1)),
                    ),
                  )
                ]),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                      itemCount: widget.poets.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              authorProfile,
                              arguments: PoetScreenArguments(
                                id: widget.poets[index].id,
                              ),
                            );
                          },
                          child: AbsorbPointer(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 12),
                              child: PoetsListTile(poet: widget.poets[index]),
                            ),
                          ),
                        );
                      }),
                ),
                Row(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      AppLocalizations.of(context)!.trending_shers,
                      style: const TextStyle(
                          fontSize: 12, color: Color.fromRGBO(93, 86, 250, 1)),
                    ),
                  )
                ]),
                SizedBox(
                  height: 150,
                  child: PageView.builder(
                      itemCount: trendShers.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 12),
                          child: TrendingSherTile(
                            sher: trendShers[index],
                            // txt:
                            //     'کتنے عیش سے رہتے ہوں گے کتنے اتراتے ہوں گے\nجانے کیسے لوگ وہ ہوں گے جو اس کو بھاتے ہوں گے',
                          ),
                        );
                      }),
                ),
                Row(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      AppLocalizations.of(context)!.sher_collections,
                      style: const TextStyle(
                          fontSize: 12, color: Color.fromRGBO(93, 86, 250, 1)),
                    ),
                  )
                ]),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                      itemCount: widget.categories.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              categoryProfile,
                              arguments: CategoryProfilArguments(
                                id: widget.categories[index].id,
                              ),
                            );
                          },
                          child: AbsorbPointer(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 12),
                              child: CategoriesListTile(
                                  category: widget.categories[index]),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          children =
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            GestureDetector(
              onTap: () {
                poetsLikesFuture = getPoetsLikes();
                categoriesLikesFuture = getCategoriesLikes();
              },
              child: const Icon(
                Icons.refresh,
                color: Colors.red,
                size: 60,
              ),
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
