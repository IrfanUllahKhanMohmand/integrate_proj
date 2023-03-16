import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:integration_test/model/category.dart';
import 'package:integration_test/model/ghazal.dart';
import 'package:integration_test/model/nazam.dart';
import 'package:integration_test/model/poet.dart';
import 'package:integration_test/model/sher.dart';
import 'package:integration_test/screens/PoetsList/widgets/top_bar_tabs.dart';

import 'package:http/http.dart' as http;

class PoetsList extends StatefulWidget {
  const PoetsList({Key? key}) : super(key: key);

  @override
  State<PoetsList> createState() => _PoetsListState();
}

class _PoetsListState extends State<PoetsList> {
  List<Poet> poets = [];
  List<Category> categories = [];
  List<Nazam> nazams = [];
  List<Ghazal> ghazals = [];
  List<Sher> shers = [];
  Future fetchPoets() async {
    final response =
        await http.get(Uri.parse('http://192.168.18.185:8080/poets'));
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
    final response =
        await http.get(Uri.parse('http://192.168.18.185:8080/category'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        categories = data.map((json) => Category.fromJson(json)).toList();
      });

      return categories;
    } else {
      throw Exception('Failed to fetch poets');
    }
  }

  Future getNazams() async {
    var response = await http.get(
      Uri.parse('http://192.168.18.185:8080/nazams'),
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
      Uri.parse('http://192.168.18.185:8080/ghazals'),
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
      Uri.parse('http://192.168.18.185:8080/shers'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        shers = data.map((entry) => Sher.fromJson(entry)).toList();
      });
      return shers;
    }
  }

  late final Future categoryFuture = fetchCategories();
  late final Future poetFuture = fetchCategories();
  late final Future nazamsFuture = getNazams();
  late final Future ghazalsFuture = getGhazals();
  late final Future shersFuture = getShers();
  @override
  void initState() {
    fetchPoets();
    fetchCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // appBar: AppBar(
      //   backgroundColor: const Color.fromRGBO(93, 86, 250, 1),
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       const SizedBox(width: 4),
      //       // GestureDetector(
      //       //     onTap: () {
      //       //       // Navigator.pop(context);
      //       //     },
      //       //     child: const Icon(Icons.arrow_back)),
      //       const Text(
      //         'Nawees',
      //         style: TextStyle(),
      //       ),
      //       Row(
      //         children: const [
      //           Icon(Icons.search),
      //           SizedBox(width: 15),
      //           Icon(Icons.more_vert)
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
      body: SafeArea(
          child: FutureBuilder(
        future: Future.wait([
          categoryFuture,
          poetFuture,
          nazamsFuture,
          ghazalsFuture,
          shersFuture
        ]), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          Widget children;
          if (snapshot.hasData) {
            children = Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * .80,
                  height: MediaQuery.of(context).size.height * .20,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: const Color.fromRGBO(93, 86, 250, 1))),
                ),
                TopBarTabs(
                  categories: categories,
                  poets: poets,
                  nazams: nazams,
                  ghazals: ghazals,
                  shers: shers,
                )
              ],
            );
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
      )),
    );
  }
}
