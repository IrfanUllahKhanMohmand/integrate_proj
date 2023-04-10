import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
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
  late Poet poetData;
  List nazamsData = [];
  List ghazalsData = [];
  List shersData = [];
  Future getPoetData() async {
    var response = await http.get(
      Uri.parse('http://nawees.com/api/poets/${widget.id}'),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $apiKey",
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        poetData = Poet.fromJson(jsonDecode(response.body));
      });
      return poetData;
    } else {
      throw Exception('Failed to get poet data');
    }
  }

  Future getNazamsData() async {
    var response = await http.get(
      Uri.parse('http://nawees.com/api/nazamsByPoet?poet_id=${widget.id}'),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $apiKey",
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        nazamsData = jsonDecode(response.body)
            .map((entry) => Nazam.fromJson(entry))
            .toList();
      });
      return nazamsData;
    } else {
      throw Exception('Failed to get nazams data');
    }
  }

  Future getGhazalsData() async {
    var response = await http.get(
      Uri.parse('http://nawees.com/api/ghazalsByPoet?poet_id=${widget.id}'),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $apiKey",
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        ghazalsData = jsonDecode(response.body)
            .map((entry) => Ghazal.fromJson(entry))
            .toList();
      });
      return ghazalsData;
    } else {
      throw Exception('Failed to get ghazal data');
    }
  }

  Future getShersData() async {
    var response = await http.get(
      Uri.parse('http://nawees.com/api/shersByPoet?poet_id=${widget.id}'),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $apiKey",
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        shersData = jsonDecode(response.body)
            .map((entry) => Sher.fromJson(entry))
            .toList();
      });
      return shersData;
    } else {
      throw Exception('Failed to get shers data');
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
