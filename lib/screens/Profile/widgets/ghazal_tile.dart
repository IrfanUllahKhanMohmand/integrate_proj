import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:integration_test/Providers/local_provider.dart';
import 'package:integration_test/model/ghazal.dart';
import 'package:provider/provider.dart';

class GhazalTile extends StatefulWidget {
  const GhazalTile({Key? key, required this.ghazal, required this.isLiked})
      : super(key: key);
  final Ghazal ghazal;
  final bool isLiked;
  @override
  State<GhazalTile> createState() => _GhazalTileState();
}

class _GhazalTileState extends State<GhazalTile> {
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
            Consumer<LocaleProvider>(builder: (context, value, child) {
              return value.locale!.languageCode == 'ur'
                  ? Column(
                      children: [
                        Text(widget.ghazal.content.split('\n')[0]),
                        Text(widget.ghazal.content.split('\n')[1])
                        // Text('کتنے عیش سے رہتے ہوں گے کتنے اتراتے ہوں گے'),
                        // Text('جانے کیسے لوگ وہ ہوں گے جو اس کو بھاتے ہوں گے'),
                      ],
                    )
                  : Column(
                      children: [
                        Text(widget.ghazal.romanContent.split('\n')[0]),
                        Text(widget.ghazal.romanContent.split('\n')[1])
                        // Text('کتنے عیش سے رہتے ہوں گے کتنے اتراتے ہوں گے'),
                        // Text('جانے کیسے لوگ وہ ہوں گے جو اس کو بھاتے ہوں گے'),
                      ],
                    );
            }),
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
