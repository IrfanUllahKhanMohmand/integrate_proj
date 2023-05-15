import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
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
  late StreamSubscription _connectivitySubscription;
  bool _isConnectionSuccessful = false;
  List<Poet> poets = [];
  List<Category> categories = [];
  List<Nazam> nazams = [];
  List<Ghazal> ghazals = [];
  List<Sher> shers = [];
  List trendingShers = [];
  Future fetchPoets() async {
    final response = await http.get(
      Uri.parse('http://nawees.com/api/poets'),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $apiKey",
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        poets = data.map((json) => Poet.fromJson(json)).toList();
      });
      return poets;
    } else {
      throw Exception('Failed to fetch poets');
    }
  }

  Future fetchCategories() async {
    final response = await http.get(
      Uri.parse('http://nawees.com/api/category'),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $apiKey",
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        categories = data.map((json) => Category.fromJson(json)).toList();
      });

      return categories;
    } else {
      throw Exception('Failed to fetch categories');
    }
  }

  Future getNazams() async {
    var response = await http.get(
      Uri.parse('http://nawees.com/api/nazams'),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $apiKey",
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        nazams = data.map((entry) => Nazam.fromJson(entry)).toList();
      });
      return nazams;
    }
  }

  Future getGhazals() async {
    var response = await http.get(
      Uri.parse('http://nawees.com/api/ghazals'),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $apiKey",
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        ghazals = data.map((entry) => Ghazal.fromJson(entry)).toList();
      });
      return ghazals;
    }
  }

  Future getShers() async {
    var response = await http.get(
      Uri.parse('http://nawees.com/api/shers'),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $apiKey",
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        shers = data.map((entry) => Sher.fromJson(entry)).toList();
      });
      return shers;
    }
  }

  Future getTrendingShers() async {
    var response = await http.get(
      Uri.parse('http://nawees.com/api/sherranks'),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $apiKey",
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        trendingShers = data;
      });
      return trendingShers;
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
    if (prefs.getInt('uusrsid') != null) {
      final int userId = prefs.getInt('uusrsid') ?? id;
      Provider.of<UserProvider>(context, listen: false).set(userId);
    } else {
      try {
        await createUser(id);
        await prefs.setInt('uusrsid', id);
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
