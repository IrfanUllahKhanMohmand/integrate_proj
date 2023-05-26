import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:integration_test/model/category.dart';
import 'package:integration_test/model/ghazal.dart';
import 'package:integration_test/model/nazam.dart';
import 'package:integration_test/model/sher.dart';
import 'package:integration_test/screens/Category/widgets/cat_profile_tob_bar.dart';
import 'package:integration_test/screens/Category/widgets/cat_tab_bar_tabs.dart';

import 'package:http/http.dart' as http;
import 'package:integration_test/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryProfile extends StatefulWidget {
  const CategoryProfile({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<CategoryProfile> createState() => _CategoryProfileState();
}

class _CategoryProfileState extends State<CategoryProfile> {
  DefaultCacheManager cacheManager = DefaultCacheManager();
  late Category categoryData;
  List nazamsData = [];
  List ghazalsData = [];
  List shersData = [];
  // Future getCategoryData() async {
  //   var response = await http.get(
  //     Uri.parse('http://nawees.com/api/category/${widget.id}'),
  //     headers: {
  //       HttpHeaders.authorizationHeader: "Bearer $apiKey",
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       categoryData = Category.fromJson(jsonDecode(response.body));
  //     });
  //     return categoryData;
  //   }
  // }

  Future getCategoryData() async {
    const String url = 'http://nawees.com/api/category';

    String cacheKey = '${url}_${widget.id}';
    // Check if the response is already cached
    FileInfo? cachedFile = await cacheManager.getFileFromCache(cacheKey);
    if (cachedFile != null) {
      // Data exists in the cache, read and parse it
      final String cachedData = await cachedFile.file.readAsString();
      final dynamic data = jsonDecode(cachedData);
      final Category cachedPoet = Category.fromJson(data);
      setState(() {
        categoryData = cachedPoet;
      });
      return cachedPoet;
    } else {
      // Data not found in the cache, fetch it from the API
      var response = await http.get(
        Uri.parse('$url/${widget.id}'),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $apiKey",
        },
      );

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        final Category fetchedPoet = Category.fromJson(data);

        // Cache the fetched data
        final Uint8List bytes = Uint8List.fromList(utf8.encode(response.body));
        await cacheManager.putFile(cacheKey, bytes);

        setState(() {
          categoryData = fetchedPoet;
        });
        return fetchedPoet;
      } else {
        throw Exception('Failed to get poet data');
      }
    }
  }

  Future getNazamsData() async {
    const String url = 'http://nawees.com/api/nazamsByCategory';

    String cacheKey = '${url}_${widget.id}';
    // Check if the response is already cached
    FileInfo? cachedFile = await cacheManager.getFileFromCache(cacheKey);
    if (cachedFile != null) {
      // Data exists in the cache, read and parse it
      final String cachedData = await cachedFile.file.readAsString();
      final List<dynamic> data = jsonDecode(cachedData);
      final List<Nazam> cachedNazams =
          data.map((entry) => Nazam.fromJson(entry)).toList();

      setState(() {
        nazamsData = cachedNazams;
      });
      return cachedNazams;
    } else {
      // Data not found in the cache, fetch it from the API
      var response = await http.get(
        Uri.parse('$url?cat_id=${widget.id}'),
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
          nazamsData = fetchedNazams;
        });
        return fetchedNazams;
      } else {
        throw Exception('Failed to get nazams data');
      }
    }
  }

  // Future getNazamsData() async {
  //   var response = await http.get(
  //     Uri.parse('http://nawees.com/api/nazamsByCategory?cat_id=${widget.id}'),
  //     headers: {
  //       HttpHeaders.authorizationHeader: "Bearer $apiKey",
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       nazamsData = jsonDecode(response.body)
  //           .map((entry) => Nazam.fromJson(entry))
  //           .toList();
  //     });
  //     return nazamsData;
  //   }
  // }

  Future getGhazalsData() async {
    const String url = 'http://nawees.com/api/ghazalsByCategory';
    String cacheKey = '${url}_${widget.id}';
    // Check if the response is already cached
    FileInfo? cachedFile = await cacheManager.getFileFromCache(cacheKey);
    if (cachedFile != null) {
      // Data exists in the cache, read and parse it
      final String cachedData = await cachedFile.file.readAsString();
      final List<dynamic> data = jsonDecode(cachedData);
      final List<Ghazal> cachedGhazals =
          data.map((entry) => Ghazal.fromJson(entry)).toList();

      setState(() {
        ghazalsData = cachedGhazals;
      });
      return cachedGhazals;
    } else {
      // Data not found in the cache, fetch it from the API
      var response = await http.get(
        Uri.parse('$url?cat_id=${widget.id}'),
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
          ghazalsData = fetchedGhazals;
        });
        return fetchedGhazals;
      } else {
        throw Exception('Failed to get ghazal data');
      }
    }
  }

  // Future getGhazalsData() async {
  //   var response = await http.get(
  //     Uri.parse('http://nawees.com/api/ghazalsByCategory?cat_id=${widget.id}'),
  //     headers: {
  //       HttpHeaders.authorizationHeader: "Bearer $apiKey",
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       ghazalsData = jsonDecode(response.body)
  //           .map((entry) => Ghazal.fromJson(entry))
  //           .toList();
  //     });
  //     return ghazalsData;
  //   }
  // }

  Future getShersData() async {
    const String url = 'http://nawees.com/api/shersByCategory';

    String cacheKey = '${url}_${widget.id}';
    // Check if the response is already cached
    FileInfo? cachedFile = await cacheManager.getFileFromCache(cacheKey);
    if (cachedFile != null) {
      // Data exists in the cache, read and parse it
      final String cachedData = await cachedFile.file.readAsString();
      final List<dynamic> data = jsonDecode(cachedData);
      final List<Sher> cachedShers =
          data.map((entry) => Sher.fromJson(entry)).toList();
      setState(() {
        shersData = cachedShers;
      });
      return cachedShers;
    } else {
      // Data not found in the cache, fetch it from the API
      var response = await http.get(
        Uri.parse('$url?cat_id=${widget.id}'),
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
          shersData = fetchedShers;
        });
        return fetchedShers;
      } else {
        throw Exception('Failed to get shers data');
      }
    }
  }

  // Future getShersData() async {
  //   var response = await http.get(
  //     Uri.parse('http://nawees.com/api/shersByCategory?cat_id=${widget.id}'),
  //     headers: {
  //       HttpHeaders.authorizationHeader: "Bearer $apiKey",
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       shersData = jsonDecode(response.body)
  //           .map((entry) => Sher.fromJson(entry))
  //           .toList();
  //     });
  //     return shersData;
  //   }
  // }

  late final Future categoryFuture = getCategoryData();
  late final Future nazamsFuture = getNazamsData();
  late final Future ghazalsFuture = getGhazalsData();
  late final Future shersFuture = getShersData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: FutureBuilder(
          future: Future.wait([
            categoryFuture,
            nazamsFuture,
            ghazalsFuture,
            shersFuture
          ]), // a previously-obtained Future<String> or null
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            Widget children;
            if (snapshot.hasData) {
              children = Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .28,
                    child: CategoryProfileTobBar(cat: categoryData),
                  ),
                  CategoryTabBarTabs(
                    cat: categoryData,
                    nazams: nazamsData,
                    ghazals: ghazalsData,
                    shers: shersData,
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              children = Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                      child:
                          Text(AppLocalizations.of(context)!.awaiting_result),
                    ),
                  ]);
            }
            return Center(
              child: children,
            );
          },
        ),
      ),
    );
  }
}
