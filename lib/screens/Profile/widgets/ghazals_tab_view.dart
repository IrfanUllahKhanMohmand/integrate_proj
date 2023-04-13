import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:integration_test/Providers/ghazals_likes_provider.dart';
import 'package:integration_test/Providers/user_provider.dart';
import 'package:integration_test/model/poet.dart';
import 'package:integration_test/screens/Profile/widgets/ghazal_tile.dart';
import 'package:integration_test/utils/constants.dart';
import 'package:integration_test/utils/on_generate_routes.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GhazalsTabView extends StatefulWidget {
  const GhazalsTabView({super.key, required this.ghazals, required this.poet});
  final List ghazals;
  final Poet poet;

  @override
  State<GhazalsTabView> createState() => _GhazalsTabViewState();
}

class _GhazalsTabViewState extends State<GhazalsTabView> {
  Map ghazalsData = {};
  getGhazalsLikes() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final ghazalProvider =
        Provider.of<GhazalLikesProvider>(context, listen: false);
    for (var element in widget.ghazals) {
      var response = await http.get(
        Uri.parse(
            'http://nawees.com/api/ghazallikes?user_id=${userProvider.userId}&ghazal_id=${element.id}'),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $apiKey",
        },
      );
      if (response.statusCode == 200) {
        ghazalsData = await jsonDecode(response.body);
        ghazalProvider.add({element.id: ghazalsData.values.first});
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
          children = Consumer<GhazalLikesProvider>(
              builder: (context, ghazalProv, child) {
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: widget.ghazals.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              ghazalPreview,
                              arguments: GhazalPreviewArguments(
                                  ghazal: widget.ghazals[index],
                                  poet: widget.poet),
                            );
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: GhazalTile(
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
