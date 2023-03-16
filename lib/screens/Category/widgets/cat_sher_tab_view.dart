import 'package:flutter/material.dart';
import 'package:integration_test/model/category.dart';
import 'package:integration_test/screens/Category/widgets/cat_profile_sher_tile.dart';

import 'package:share_plus/share_plus.dart';

class CategorySherTabView extends StatefulWidget {
  const CategorySherTabView(
      {super.key, required this.shers, required this.cat});
  final List shers;
  final Category cat;
  @override
  State<CategorySherTabView> createState() => _CategorySherTabViewState();
}

class _CategorySherTabViewState extends State<CategorySherTabView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("SHER",
                  style: TextStyle(color: Color.fromRGBO(93, 86, 250, 1))),
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