import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:integration_test/Providers/shers_likes_provider.dart';
import 'package:integration_test/Providers/user_provider.dart';
import 'package:integration_test/model/sher.dart';
import 'package:integration_test/screens/PoetsList/widgets/tab_bar_sher_tile.dart';
import 'package:integration_test/utils/constants.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SherList extends StatefulWidget {
  const SherList({Key? key, required this.shers}) : super(key: key);
  final List<Sher> shers;
  @override
  State<SherList> createState() => _SherListState();
}

class _SherListState extends State<SherList> {
  Map shersData = {};

  getshersLikes() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final sherProvider = Provider.of<SherLikesProvider>(context, listen: false);
    for (var element in widget.shers) {
      var response = await http.get(
        Uri.parse(
            'http://nawees.com/api/sherlikes?user_id=${userProvider.userId}&sher_id=${element.id}'),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $apiKey",
        },
      );
      if (response.statusCode == 200) {
        shersData = await jsonDecode(response.body);

        sherProvider.add({element.id: shersData.values.first});
        setState(() {});
      }
    }

    return sherProvider.likes;
  }

  late final Future ghazalsLikesFuture = getshersLikes();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([ghazalsLikesFuture]),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        Widget children;
        if (snapshot.hasData) {
          children = Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: widget.shers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6),
                        child: TabBarSherTile(sher: widget.shers[index]),
                      );
                    }),
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
