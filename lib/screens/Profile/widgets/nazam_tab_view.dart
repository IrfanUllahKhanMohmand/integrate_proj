import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:integration_test/Providers/nazams_likes_provider.dart';
import 'package:integration_test/Providers/user_provider.dart';
import 'package:integration_test/model/poet.dart';
import 'package:integration_test/screens/PoetsList/widgets/tab_nazam_tile.dart';
import 'package:integration_test/utils/constants.dart';
import 'package:integration_test/utils/on_generate_routes.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class NazamsTabView extends StatefulWidget {
  const NazamsTabView({super.key, required this.nazams, required this.poet});
  final List nazams;
  final Poet poet;

  @override
  State<NazamsTabView> createState() => _NazamsTabViewState();
}

class _NazamsTabViewState extends State<NazamsTabView> {
  Map nazamsData = {};

  getNazamsLikes() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final nazamProvider =
        Provider.of<NazamLikesProvider>(context, listen: false);
    for (var element in widget.nazams) {
      var response = await http.get(
        Uri.parse(
            'http://nawees.com/api/nazamlikes?user_id=${userProvider.userId}&nazam_id=${element.id}'),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $apiKey",
        },
      );
      if (response.statusCode == 200) {
        nazamsData = await jsonDecode(response.body);
        nazamProvider.add({element.id: nazamsData.values.first});
        setState(() {});
      }
    }

    return nazamProvider.likes;
  }

  late final Future nazamsFuture = getNazamsLikes();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([nazamsFuture]),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        Widget children;
        if (snapshot.hasData) {
          children =
              Consumer<NazamLikesProvider>(builder: (context, nazam, child) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("NAZAM",
                          style:
                              TextStyle(color: Color.fromRGBO(93, 86, 250, 1))),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: widget.nazams.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              nazamPreview,
                              arguments: NazamPreviewArguments(
                                  nazam: widget.nazams[index],
                                  poet: widget.poet),
                            );
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: TabNazamTile(
                                  nazam: widget.nazams[index],
                                  isLiked:
                                      nazam.likes[widget.nazams[index].id] != 0,
                                ),
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
