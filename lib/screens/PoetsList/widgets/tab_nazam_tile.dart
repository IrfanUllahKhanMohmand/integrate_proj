import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:integration_test/Providers/local_provider.dart';
import 'package:integration_test/model/nazam.dart';
import 'package:provider/provider.dart';

class TabNazamTile extends StatefulWidget {
  const TabNazamTile({Key? key, required this.nazam, required this.isLiked})
      : super(key: key);
  final Nazam nazam;
  final bool isLiked;

  @override
  State<TabNazamTile> createState() => _TabNazamTileState();
}

class _TabNazamTileState extends State<TabNazamTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .95,
      height: 82.0,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0xffDDDDDD),
            blurRadius: 6.0,
            spreadRadius: 2.0,
            offset: Offset(0.0, 0.0),
          )
        ],
        border:
            Border.all(width: 2, color: const Color.fromRGBO(112, 112, 112, 0)),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Consumer<LocaleProvider>(builder: ((context, value, child) {
              return value.locale!.languageCode == 'ur'
                  ? Column(
                      children: [
                        Text(widget.nazam.title),
                        Text(widget.nazam.content.split('\n')[0])
                        // Text('کتنے عیش سے رہتے ہوں گے کتنے اتراتے ہوں گے'),
                        // Text('جانے کیسے لوگ وہ ہوں گے جو اس کو بھاتے ہوں گے'),
                      ],
                    )
                  : Column(
                      children: [
                        Text(widget.nazam.romanTitle),
                        Text(widget.nazam.romanContent.split('\n')[0])
                        // Text('کتنے عیش سے رہتے ہوں گے کتنے اتراتے ہوں گے'),
                        // Text('جانے کیسے لوگ وہ ہوں گے جو اس کو بھاتے ہوں گے'),
                      ],
                    );
            })),
            widget.isLiked
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SvgPicture.asset(
                      "assets/favourite.svg",
                      width: 16,
                      height: 16,
                      // ignore: deprecated_member_use
                      color: Colors.red,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SvgPicture.asset(
                      "assets/favourite.svg",
                      width: 16,
                      height: 16,
                    ),
                  )
          ]),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
