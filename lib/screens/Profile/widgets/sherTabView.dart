import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:integration_test/utils/constants.dart';

import 'package:share_plus/share_plus.dart';

class SherTabView extends StatefulWidget {
  const SherTabView({key});

  @override
  State<SherTabView> createState() => _SherTabViewState();
}

class _SherTabViewState extends State<SherTabView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Text("SHER", style: TextStyle(color: Colors.white)),
                  SizedBox(width: 5),
                  Text("171", style: TextStyle(color: Colors.white)),
                ],
              ),
              const Icon(
                Icons.tune,
                color: Colors.white,
              )
            ],
          ),
        ),
        SizedBox(
          height: 360,
          child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    const ListTile(
                      title: Text(
                        'ranjish hi sahi dil hi dhukhane ke liye aa\naa phir se mujhe chhor ke jaane ke liye aa',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(children: [
                        const Icon(
                          Icons.favorite_outline,
                          color: Colors.white,
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () async {
                            // final box = context.findRenderObject() as RenderBox;
                            // await Share.share(
                            //     'ranjish hi sahi dil hi dhukhane ke liye aa\naa phir se mujhe chhor ke jaane ke liye aa',
                            //     sharePositionOrigin:
                            //         box.localToGlobal(Offset.zero) & box.size);
                            await Share.share(
                                'ranjish hi sahi dil hi dhukhane ke liye aa\naa phir se mujhe chhor ke jaane ke liye aa');
                          },
                          child: const Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
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
                          child: const Icon(
                            Icons.copy,
                            color: Colors.white,
                            size: 15,
                          ),
                        )
                      ]),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 100.0),
                      child: Divider(
                        color: Colors.white,
                        thickness: 0.2,
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                );
              }),
        ),
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
