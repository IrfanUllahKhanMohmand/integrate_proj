import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
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
  late Category categoryData;
  List nazamsData = [];
  List ghazalsData = [];
  List shersData = [];
  Future getCategoryData() async {
    var response = await http.get(
      Uri.parse('http://nawees.com/api/category/${widget.id}'),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $apiKey",
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        categoryData = Category.fromJson(jsonDecode(response.body));
      });
      return categoryData;
    }
  }

  Future getNazamsData() async {
    var response = await http.get(
      Uri.parse('http://nawees.com/api/nazamsByCategory?cat_id=${widget.id}'),
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
    }
  }

  Future getGhazalsData() async {
    var response = await http.get(
      Uri.parse('http://nawees.com/api/ghazalsByCategory?cat_id=${widget.id}'),
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
    }
  }

  Future getShersData() async {
    var response = await http.get(
      Uri.parse('http://nawees.com/api/shersByCategory?cat_id=${widget.id}'),
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
    }
  }

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
