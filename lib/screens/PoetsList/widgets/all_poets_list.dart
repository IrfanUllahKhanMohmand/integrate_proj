import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:integration_test/model/category.dart';
import 'package:integration_test/model/poet.dart';
import 'package:integration_test/screens/PoetsList/widgets/categories_list_tile.dart';
import 'package:integration_test/screens/PoetsList/widgets/poets_list_tile.dart';
import 'package:integration_test/screens/PoetsList/widgets/sher_tile.dart';
import 'package:integration_test/utils/constants.dart';

import 'package:http/http.dart' as http;
import 'package:integration_test/utils/on_generate_routes.dart';

class AllPoetsList extends StatefulWidget {
  const AllPoetsList({Key? key}) : super(key: key);

  @override
  State<AllPoetsList> createState() => _AllPoetsListState();
}

class _AllPoetsListState extends State<AllPoetsList> {
  List<Poet> poets = [];
  List<Category> categories = [];
  Future<void> fetchPoets() async {
    final response =
        await http.get(Uri.parse('http://192.168.18.185:8080/poets'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        poets = data.map((json) => Poet.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to fetch poets');
    }
  }

  Future<void> fetchCategories() async {
    final response =
        await http.get(Uri.parse('http://192.168.18.185:8080/category'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        categories = data.map((json) => Category.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to fetch poets');
    }
  }

  @override
  void initState() {
    fetchPoets();
    fetchCategories();
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
                itemCount: poets.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        authorProfile,
                        arguments: PoetScreenArguments(
                          id: poets[index].id,
                        ),
                      );
                    },
                    child: AbsorbPointer(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 12),
                        child: PoetsListTile(
                            imageUrl: poets[index].pic,
                            realName: poets[index].name),
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
                        child: SherTile(),
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
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, authorProfile);
                    },
                    child: AbsorbPointer(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 12),
                        child: CategoriesListTile(
                            imageUrl: categories[index].pic,
                            realName: categories[index].name),
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
