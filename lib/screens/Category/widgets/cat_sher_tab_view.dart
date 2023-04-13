import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:integration_test/Providers/catsher_likes_provider.dart';
import 'package:integration_test/Providers/user_provider.dart';
import 'package:integration_test/model/category.dart';
import 'package:integration_test/screens/Category/widgets/cat_profile_sher_tile.dart';
import 'package:integration_test/utils/constants.dart';
import 'package:provider/provider.dart';

import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategorySherTabView extends StatefulWidget {
  const CategorySherTabView(
      {super.key, required this.shers, required this.cat});
  final List shers;
  final Category cat;
  @override
  State<CategorySherTabView> createState() => _CategorySherTabViewState();
}

class _CategorySherTabViewState extends State<CategorySherTabView> {
  Map catshersData = {};

  getshersLikes() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final catsherProvider =
        Provider.of<CatSherLikesProvider>(context, listen: false);
    for (var element in widget.shers) {
      var response = await http.get(
        Uri.parse(
            'http://nawees.com/api/catsherlikes?user_id=${userProvider.userId}&catsher_id=${element.id}'),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $apiKey",
        },
      );
      if (response.statusCode == 200) {
        catshersData = await jsonDecode(response.body);

        catsherProvider.add({element.id: catshersData.values.first});
        setState(() {});
      }
    }

    return catsherProvider.likes;
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("SHER",
                        style:
                            TextStyle(color: Color.fromRGBO(93, 86, 250, 1))),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: widget.shers.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Navigator.pushNamed(
                          //   context,
                          //   nazamPreview,
                          // );
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: CategoryProfileSherTile(
                                sher: widget.shers[index],
                                cat: widget.cat,
                              ),
                            )
                          ],
                        ),
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

void onShare(BuildContext context) async {
  final box = context.findRenderObject() as RenderBox;
  await Share.share(
      'ranjish hi sahi dil hi dhukhane ke liye aa\naa phir se mujhe chhor ke jaane ke liye aa',
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
}




// SizedBox(
//           height: MediaQuery.of(context).size.height * .52,
//           child: ListView.builder(
//               itemCount: 20,
//               itemBuilder: (context, index) {
//                 return Column(
//                   children: [
//                     const ListTile(
//                       title: Text(
//                         'ranjish hi sahi dil hi dhukhane ke liye aa\naa phir se mujhe chhor ke jaane ke liye aa',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 18.0),
//                       child: Row(children: [
//                         const Icon(
//                           Icons.favorite_outline,
//                           color: Colors.white,
//                           size: 15,
//                         ),
//                         const SizedBox(width: 5),
//                         GestureDetector(
//                           onTap: () async {
//                             // final box = context.findRenderObject() as RenderBox;
//                             // await Share.share(
//                             //     'ranjish hi sahi dil hi dhukhane ke liye aa\naa phir se mujhe chhor ke jaane ke liye aa',
//                             //     sharePositionOrigin:
//                             //         box.localToGlobal(Offset.zero) & box.size);
//                             await Share.share(
//                                 'ranjish hi sahi dil hi dhukhane ke liye aa\naa phir se mujhe chhor ke jaane ke liye aa');
//                           },
//                           child: const Icon(
//                             Icons.share,
//                             color: Colors.white,
//                             size: 15,
//                           ),
//                         ),
//                         const SizedBox(width: 5),
//                         GestureDetector(
//                           onTap: () async {
//                             await Clipboard.setData(const ClipboardData(
//                                 text:
//                                     'ranjish hi sahi dil hi dhukhane ke liye aa\naa phir se mujhe chhor ke jaane ke liye aa'));
//                             // copied successfully
//                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                               content: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: const [
//                                   Text(
//                                     'copied successfully',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 ],
//                               ),
//                               duration: const Duration(seconds: 1),
//                               backgroundColor: Colors.transparent,
//                             ));

//                             Navigator.pushNamed(context, storiesEditor);
//                           },
//                           child: const Icon(
//                             Icons.copy,
//                             color: Colors.white,
//                             size: 15,
//                           ),
//                         )
//                       ]),
//                     ),
//                     const SizedBox(height: 10),
//                     const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 100.0),
//                       child: Divider(
//                         color: Colors.white,
//                         thickness: 0.2,
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                   ],
//                 );
//               }),
//         )