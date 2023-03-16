import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:integration_test/model/category.dart';
import 'package:integration_test/model/poet.dart';
import 'package:integration_test/screens/PoetsList/widgets/categories_list_tile.dart';
import 'package:integration_test/screens/PoetsList/widgets/poets_list_tile.dart';
import 'package:integration_test/screens/PoetsList/widgets/trending_sher_tile.dart';
import 'package:integration_test/utils/constants.dart';

import 'package:integration_test/utils/on_generate_routes.dart';

class AllPoetsList extends StatefulWidget {
  const AllPoetsList({Key? key, required this.poets, required this.categories})
      : super(key: key);
  final List<Poet> poets;
  final List<Category> categories;

  @override
  State<AllPoetsList> createState() => _AllPoetsListState();
}

class _AllPoetsListState extends State<AllPoetsList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              InkWell(
                onTap: () async {
                  await Clipboard.setData(const ClipboardData(
                      text:
                          'ranjish hi sahi dil hi dhukhane ke liye aa\naa phir se mujhe chhor ke jaane ke liye aa'));
                  // copied successfully
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'copied successfully',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    duration: const Duration(seconds: 1),
                    backgroundColor: Colors.transparent,
                  ));

                  Navigator.pushNamed(context, storiesEditor);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * .45,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      gradient: const LinearGradient(colors: [
                        Color.fromRGBO(37, 28, 216, 1),
                        Color.fromRGBO(37, 28, 216, 0.6),
                      ]),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          "assets/picture.svg",
                          width: 40,
                          height: 40,
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                        ),
                        const Text(
                          'Make Status',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              InkWell(
                onTap: () async {
                  await Clipboard.setData(const ClipboardData(
                      text:
                          'ranjish hi sahi dil hi dhukhane ke liye aa\naa phir se mujhe chhor ke jaane ke liye aa'));
                  // copied successfully
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'copied successfully',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    duration: const Duration(seconds: 1),
                    backgroundColor: Colors.transparent,
                  ));

                  Navigator.pushNamed(context, projectEdit);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * .45,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      gradient: const LinearGradient(colors: [
                        Color.fromRGBO(37, 28, 216, 1),
                        Color.fromRGBO(121, 115, 248, 1)
                      ]),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          "assets/videoCamera.svg",
                          width: 40,
                          height: 40,
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                        ),
                        const Text(
                          'Make Video',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ),
          Row(children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Most Read Poets',
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(93, 86, 250, 1)),
              ),
            )
          ]),
          SizedBox(
            height: 150,
            child: ListView.builder(
                itemCount: widget.poets.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        authorProfile,
                        arguments: PoetScreenArguments(
                          id: widget.poets[index].id,
                        ),
                      );
                    },
                    child: AbsorbPointer(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 12),
                        child: PoetsListTile(
                            imageUrl: widget.poets[index].pic,
                            realName: widget.poets[index].name),
                      ),
                    ),
                  );
                }),
          ),
          Row(children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Trending Sher',
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(93, 86, 250, 1)),
              ),
            )
          ]),
          SizedBox(
            height: 150,
            child: PageView.builder(
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, authorProfile);
                    },
                    child: const AbsorbPointer(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 12),
                        child: TrendingSherTile(),
                      ),
                    ),
                  );
                }),
          ),
          Row(children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Sher Collections',
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(93, 86, 250, 1)),
              ),
            )
          ]),
          SizedBox(
            height: 150,
            child: ListView.builder(
                itemCount: widget.categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        categoryProfile,
                        arguments: CategoryProfilArguments(
                          id: widget.categories[index].id,
                        ),
                      );
                    },
                    child: AbsorbPointer(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 12),
                        child: CategoriesListTile(
                            imageUrl: widget.categories[index].pic,
                            realName: widget.categories[index].name),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
