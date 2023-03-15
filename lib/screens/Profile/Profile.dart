import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:integration_test/model/ghazal.dart';
import 'package:integration_test/model/nazam.dart';
import 'package:integration_test/model/poet.dart';
import 'package:integration_test/model/sher.dart';
import 'package:integration_test/screens/Profile/widgets/profile_tob_bar.dart';
import 'package:integration_test/screens/Profile/widgets/tab_bar_tabs.dart';

import 'package:http/http.dart' as http;

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
      Uri.parse('http://192.168.18.185:8080/poets/${widget.id}'),
    );
    if (response.statusCode == 200) {
      setState(() {
        poetData = Poet.fromJson(jsonDecode(response.body));
      });
      return poetData;
    }
  }

  Future getNazamsData() async {
    var response = await http.get(
      Uri.parse('http://192.168.18.185:8080/nazamsByPoet?poet_id=${widget.id}'),
    );
    if (response.statusCode == 200) {
      setState(() {
        nazamsData = jsonDecode(response.body)
            .map((entry) => Nazam.fromJson(entry))
            .toList();
      });
      return nazamsData;
    }
  }

  Future getGhazalsData() async {
    var response = await http.get(
      Uri.parse(
          'http://192.168.18.185:8080/ghazalsByPoet?poet_id=${widget.id}'),
    );
    if (response.statusCode == 200) {
      setState(() {
        ghazalsData = jsonDecode(response.body)
            .map((entry) => Ghazal.fromJson(entry))
            .toList();
      });
      return ghazalsData;
    }
  }

  Future getShersData() async {
    var response = await http.get(
      Uri.parse('http://192.168.18.185:8080/shersByPoet?poet_id=${widget.id}'),
    );
    if (response.statusCode == 200) {
      setState(() {
        shersData = jsonDecode(response.body)
            .map((entry) => Sher.fromJson(entry))
            .toList();
      });
      return shersData;
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
                    height: MediaQuery.of(context).size.height * .28,
                    child: ProfileTobBar(
                      imageUrl: poetData.pic,
                      fullName: poetData.name,
                      yearOfBirth: poetData.birthDate,
                      yearOfDeath: poetData.deathDate,
                      birthPlace: "Peshawar",
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
                  children: const [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Awaiting result...'),
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
