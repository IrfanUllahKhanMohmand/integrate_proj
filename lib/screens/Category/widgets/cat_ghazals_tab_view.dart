import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:integration_test/Providers/catghazals_likes_provider.dart';
import 'package:integration_test/Providers/user_provider.dart';
import 'package:integration_test/model/category.dart';
import 'package:integration_test/screens/Category/widgets/cat_ghazal_tile.dart';
import 'package:integration_test/utils/constants.dart';
import 'package:integration_test/utils/on_generate_routes.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CategoryGhazalsTabView extends StatefulWidget {
  const CategoryGhazalsTabView(
      {super.key, required this.ghazals, required this.cat});
  final List ghazals;
  final Category cat;

  @override
  State<CategoryGhazalsTabView> createState() => _CategoryGhazalsTabViewState();
}

class _CategoryGhazalsTabViewState extends State<CategoryGhazalsTabView> {
  Map catghazalsData = {};
  getGhazalsLikes() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final ghazalProvider =
        Provider.of<CatGhazalLikesProvider>(context, listen: false);
    for (var element in widget.ghazals) {
      var response = await http.get(
        Uri.parse(
            'http://nawees.com/api/catghazallikes?user_id=${userProvider.userId}&catghazal_id=${element.id}'),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $apiKey",
        },
      );
      if (response.statusCode == 200) {
        catghazalsData = await jsonDecode(response.body);
        ghazalProvider.add({element.id: catghazalsData.values.first});
        setState(() {});
      }
    }

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
          children = Consumer<CatGhazalLikesProvider>(
              builder: (context, ghazalProv, child) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("GHAZAL",
                          style:
                              TextStyle(color: Color.fromRGBO(93, 86, 250, 1))),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: widget.ghazals.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              categoryGhazalPreview,
                              arguments: CategoryGhazalPreviewArguments(
                                  ghazal: widget.ghazals[index],
                                  cat: widget.cat),
                            );
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: CategoryGhazalTile(
                                    ghazal: widget.ghazals[index],
                                    isLiked: ghazalProv
                                            .likes[widget.ghazals[index].id] !=
                                        0),
                              )
                            ],
                          ),
                        );
                      }),
                ),
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
    );
  }
}
