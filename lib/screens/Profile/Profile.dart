import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:integration_test/model/ghazal.dart';
import 'package:integration_test/model/nazam.dart';
import 'package:integration_test/model/poet.dart';
import 'package:integration_test/model/sher.dart';
import 'package:integration_test/screens/Profile/widgets/profile_tob_bar.dart';
import 'package:integration_test/screens/Profile/widgets/tab_bar_tabs.dart';

import 'package:http/http.dart' as http;
import 'package:integration_test/utils/constants.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  DefaultCacheManager cacheManager = DefaultCacheManager();
  late Poet poetData;
  List nazamsData = [];
  List ghazalsData = [];
  List shersData = [];
  Future getPoetData() async {
    const String url = 'http://nawees.com/api/poets';

    String cacheKey = '${url}_${widget.id}';
    // Check if the response is already cached
    FileInfo? cachedFile = await cacheManager.getFileFromCache(cacheKey);
    if (cachedFile != null) {
      // Data exists in the cache, read and parse it
      final String cachedData = await cachedFile.file.readAsString();
      final dynamic data = jsonDecode(cachedData);
      final Poet cachedPoet = Poet.fromJson(data);
      setState(() {
        poetData = cachedPoet;
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
        final Poet fetchedPoet = Poet.fromJson(data);

        // Cache the fetched data
        final Uint8List bytes = Uint8List.fromList(utf8.encode(response.body));
        await cacheManager.putFile(cacheKey, bytes);

        setState(() {
          poetData = fetchedPoet;
        });
        return fetchedPoet;
      } else {
        throw Exception('Failed to get poet data');
      }
    }
  }

  Future getNazamsData() async {
    const String url = 'http://nawees.com/api/nazamsByPoet';

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
        Uri.parse('$url?poet_id=${widget.id}'),
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

  Future getGhazalsData() async {
    const String url = 'http://nawees.com/api/ghazalsByPoet';
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
        Uri.parse('$url?poet_id=${widget.id}'),
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

  Future getShersData() async {
    const String url = 'http://nawees.com/api/shersByPoet';

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
        Uri.parse('$url?poet_id=${widget.id}'),
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

  late final Future poetFuture = getPoetData();
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
            poetFuture,
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
                    height: MediaQuery.of(context).size.height * .30,
                    child: ProfileTobBar(
                      poet: poetData,
                    ),
                  ),
                  TabBarTabs(
                    poet: poetData,
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
