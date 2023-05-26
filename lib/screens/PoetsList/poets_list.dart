import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:integration_test/Providers/admob_provider.dart';
import 'package:integration_test/Providers/local_provider.dart';
import 'package:integration_test/Providers/user_provider.dart';
import 'package:integration_test/model/category.dart';
import 'package:integration_test/model/ghazal.dart';
import 'package:integration_test/model/nazam.dart';
import 'package:integration_test/model/poet.dart';
import 'package:integration_test/model/sher.dart';
import 'package:integration_test/screens/PoetsList/widgets/top_bar_tabs.dart';

import 'package:http/http.dart' as http;
import 'package:integration_test/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PoetsList extends StatefulWidget {
  const PoetsList({Key? key}) : super(key: key);

  @override
  State<PoetsList> createState() => _PoetsListState();
}

class _PoetsListState extends State<PoetsList> {
  DefaultCacheManager cacheManager = DefaultCacheManager();
  late StreamSubscription _connectivitySubscription;
  bool _isConnectionSuccessful = false;
  List<Poet> poets = [];
  List<Category> categories = [];
  List<Nazam> nazams = [];
  List<Ghazal> ghazals = [];
  List<Sher> shers = [];
  List trendingShers = [];

  Future<List<Poet>> fetchPoets() async {
    const String url = 'http://nawees.com/api/poets';

    // Check if the response is already cached
    FileInfo? cachedFile = await cacheManager.getFileFromCache(url);
    if (cachedFile != null) {
      // Data exists in the cache, read and parse it
      final String cachedData = await cachedFile.file.readAsString();
      final List<dynamic> data = jsonDecode(cachedData);
      final List<Poet> cachedPoets =
          data.map((json) => Poet.fromJson(json)).toList();
      setState(() {
        poets = cachedPoets;
      });
      return cachedPoets;
    } else {
      // Data not found in the cache, fetch it from the API
      var response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $apiKey",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Poet> fetchedPoets =
            data.map((json) => Poet.fromJson(json)).toList();

        // Cache the fetched data
        final Uint8List bytes = Uint8List.fromList(utf8.encode(response.body));
        await cacheManager.putFile(url, bytes);

        setState(() {
          poets = fetchedPoets;
        });
        return fetchedPoets;
      } else {
        throw Exception('Failed to fetch poets');
      }
    }
  }

  Future<List<Category>> fetchCategories() async {
    const String url = 'http://nawees.com/api/category';

    // Check if the response is already cached
    FileInfo? cachedFile = await cacheManager.getFileFromCache(url);
    if (cachedFile != null) {
      // Data exists in the cache, read and parse it
      final String cachedData = await cachedFile.file.readAsString();
      final List<dynamic> data = jsonDecode(cachedData);
      final List<Category> cachedCategories =
          data.map((json) => Category.fromJson(json)).toList();
      setState(() {
        categories = cachedCategories;
      });
      return cachedCategories;
    } else {
      // Data not found in the cache, fetch it from the API
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $apiKey",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Category> fetchedCategories =
            data.map((json) => Category.fromJson(json)).toList();

        // Cache the fetched data
        final Uint8List bytes = Uint8List.fromList(utf8.encode(response.body));
        await cacheManager.putFile(url, bytes);

        setState(() {
          categories = fetchedCategories;
        });
        return fetchedCategories;
      } else {
        throw Exception('Failed to fetch categories');
      }
    }
  }

  Future getNazams() async {
    const String url = 'http://nawees.com/api/nazams';
    const String cacheKey = 'nazams_data';

    // Check if the response is already cached
    FileInfo? cachedFile = await cacheManager.getFileFromCache(cacheKey);
    if (cachedFile != null) {
      // Data exists in the cache, read and parse it
      final String cachedData = await cachedFile.file.readAsString();
      final List<dynamic> data = jsonDecode(cachedData);
      final List<Nazam> cachedNazams =
          data.map((entry) => Nazam.fromJson(entry)).toList();
      setState(() {
        nazams = cachedNazams;
      });
      return cachedNazams;
    } else {
      // Data not found in the cache, fetch it from the API
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $apiKey",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Nazam> fetchedNazams =
            data.map((entry) => Nazam.fromJson(entry)).toList();

        // Cache the fetched data
        final Uint8List bytes = Uint8List.fromList(utf8.encode(response.body));
        await cacheManager.putFile(cacheKey, bytes);

        setState(() {
          nazams = fetchedNazams;
        });
        return fetchedNazams;
      }
    }
  }

  Future getGhazals() async {
    const String url = 'http://nawees.com/api/ghazals';
    const String cacheKey = 'ghazals_data';

    // Check if the response is already cached
    FileInfo? cachedFile = await cacheManager.getFileFromCache(cacheKey);
    if (cachedFile != null) {
      // Data exists in the cache, read and parse it
      final String cachedData = await cachedFile.file.readAsString();
      final List<dynamic> data = jsonDecode(cachedData);
      final List<Ghazal> cachedGhazals =
          data.map((entry) => Ghazal.fromJson(entry)).toList();
      setState(() {
        ghazals = cachedGhazals;
      });
      return cachedGhazals;
    } else {
      // Data not found in the cache, fetch it from the API
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $apiKey",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Ghazal> fetchedGhazals =
            data.map((entry) => Ghazal.fromJson(entry)).toList();

        // Cache the fetched data
        final Uint8List bytes = Uint8List.fromList(utf8.encode(response.body));
        await cacheManager.putFile(cacheKey, bytes);

        setState(() {
          ghazals = fetchedGhazals;
        });
        return fetchedGhazals;
      }
    }
  }

  Future getShers() async {
    const String url = 'http://nawees.com/api/shers';
    const String cacheKey = 'shers_data';

    // Check if the response is already cached
    FileInfo? cachedFile = await cacheManager.getFileFromCache(cacheKey);
    if (cachedFile != null) {
      // Data exists in the cache, read and parse it
      final String cachedData = await cachedFile.file.readAsString();
      final List<dynamic> data = jsonDecode(cachedData);
      final List<Sher> cachedShers =
          data.map((entry) => Sher.fromJson(entry)).toList();
      setState(() {
        shers = cachedShers;
      });
      return cachedShers;
    } else {
      // Data not found in the cache, fetch it from the API
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $apiKey",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Sher> fetchedShers =
            data.map((entry) => Sher.fromJson(entry)).toList();

        // Cache the fetched data
        final Uint8List bytes = Uint8List.fromList(utf8.encode(response.body));
        await cacheManager.putFile(cacheKey, bytes);

        setState(() {
          shers = fetchedShers;
        });
        return fetchedShers;
      }
    }
  }

  //   Future getTrendingShers() async {
  //   var response = await http.get(
  //     Uri.parse('http://nawees.com/api/sherranks'),
  //     headers: {
  //       HttpHeaders.authorizationHeader: "Bearer $apiKey",
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = jsonDecode(response.body);
  //     setState(() {
  //       trendingShers = data;
  //     });
  //     return trendingShers;
  //   }
  // }

  Future getTrendingShers() async {
    const String url = 'http://nawees.com/api/sherranks';
    const String cacheKey = 'trending_shers_data';

    // Check if the response is already cached
    FileInfo? cachedFile = await cacheManager.getFileFromCache(cacheKey);
    if (cachedFile != null) {
      // Data exists in the cache, read and parse it
      final String cachedData = await cachedFile.file.readAsString();
      final List<dynamic> cachedShers = jsonDecode(cachedData);
      setState(() {
        trendingShers = cachedShers;
      });
      return cachedShers;
    } else {
      // Data not found in the cache, fetch it from the API
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $apiKey",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> fetchedShers = jsonDecode(response.body);

        // Cache the fetched data
        final Uint8List bytes = Uint8List.fromList(utf8.encode(response.body));
        await cacheManager.putFile(cacheKey, bytes);

        setState(() {
          trendingShers = fetchedShers;
        });
        return fetchedShers;
      }
    }
  }

  createUser(int id) async {
    final response = await http.post(Uri.parse('http://nawees.com/api/user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer $apiKey",
        },
        body: jsonEncode(<String, dynamic>{
          "id": id,
        }));
    if (response.statusCode == 201) {
    } else {
      throw Exception('Failed to create user');
    }
  }

  late Future categoryFuture = fetchCategories();
  late Future poetFuture = fetchCategories();
  late Future nazamsFuture = getNazams();
  late Future ghazalsFuture = getGhazals();
  late Future shersFuture = getShers();
  late Future trendingShersFuture = getTrendingShers();

  checkForUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.remove('userid');
    final int id = DateTime.now().microsecondsSinceEpoch;
    if (prefs.getInt('uuuusrsid') != null) {
      final int userId = prefs.getInt('uuuusrsid') ?? id;
      Provider.of<UserProvider>(context, listen: false).set(userId);
    } else {
      try {
        await createUser(id);
        await prefs.setInt('uuuusrsid', id);
      } on Error {
        throw Exception('Failed to create user');
      }

      Provider.of<UserProvider>(context, listen: false).set(id);
    }
  }

  @override
  void initState() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        _isConnectionSuccessful = await DataConnectionChecker().hasConnection;
      } else {
        _isConnectionSuccessful = false;
        setState(() {});
      }

      setState(() {});
    });
    checkForUserId();
    fetchPoets();
    fetchCategories();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();

    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
          child: _isConnectionSuccessful
              ? FutureBuilder(
                  future: Future.wait([
                    categoryFuture,
                    poetFuture,
                    nazamsFuture,
                    ghazalsFuture,
                    shersFuture,
                    trendingShersFuture
                  ]), // a previously-obtained Future<String> or null
                  builder: (BuildContext context,
                      AsyncSnapshot<List<dynamic>> snapshot) {
                    Widget children;
                    if (snapshot.hasData) {
                      children = Consumer<LocaleProvider>(
                          builder: ((context, value, child) {
                        return Scaffold(
                          body: Column(
                            children: [
                              const SizedBox(height: 10),
                              Consumer<AdMobServicesProvider>(
                                builder: (context, ad, child) {
                                  return ad.isBannerAdVisible
                                      ? Container(
                                          height: 60,
                                          // width: MediaQuery.of(context).size.width *
                                          //     .80,
                                          // height:
                                          //     MediaQuery.of(context).size.height *
                                          //         .20,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: const Color.fromRGBO(
                                                      93, 86, 250, 1))),
                                          child: AdWidget(ad: ad.bannerAd!),
                                        )
                                      : Container();
                                },
                              ),
                              TopBarTabs(
                                categories: categories,
                                poets: poets,
                                nazams: nazams,
                                ghazals: ghazals,
                                shers: shers,
                                trendingShers: trendingShers,
                              ),
                            ],
                          ),
                          floatingActionButton: FloatingActionButton(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.transparent,
                            onPressed: () {},
                            child: DropdownButton(
                              value: value.locale,
                              items: AppLocalizations.supportedLocales
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e.languageCode),
                                      ))
                                  .toList(),
                              onChanged: (Locale? val) async {
                                await value.setLocale(val!);
                                // MyApp.setLocale(context, Locale(val.toString(), ""));
                              },
                            ),
                          ),
                        );
                      }));
                    } else if (snapshot.hasError) {
                      children = GestureDetector(
                        onTap: () {
                          categoryFuture = fetchCategories();
                          poetFuture = fetchCategories();
                          nazamsFuture = getNazams();
                          ghazalsFuture = getGhazals();
                          shersFuture = getShers();
                          trendingShersFuture = getTrendingShers();
                        },
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.refresh,
                                color: Colors.red,
                                size: 60,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text('Error: ${snapshot.error}'),
                              ),
                            ]),
                      );
                    } else {
                      children = Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Text(AppLocalizations.of(context)!
                                  .awaiting_result),
                            ),
                          ]);
                    }
                    return Center(
                      child: children,
                    );
                  },
                )
              : Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(AppLocalizations.of(context)!
                              .no_internet_connection),
                        ),
                      ]),
                )),
    );
  }
}
