import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:open_director/Editor/service_locator.dart';
import 'package:open_director/Editor/service/director_service.dart';
import 'package:open_director/Editor/model/model.dart';

class TextForm extends StatelessWidget {
  final directorService = locator.get<DirectorService>();
  final Asset _asset;

  TextForm(this._asset) : super();

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _SubMenu(),
      Container(
        width: MediaQuery.of(context).size.width - 120,
        child: Wrap(
          spacing: 0.0,
          runSpacing: 0.0,
          children: [
            _FontFamily(_asset),
            _FontSize(_asset),
            _ColorField(
                label: 'Color',
                field: 'fontColor',
                color: _asset.fontColor,
                size: 110),
            _ColorField(
                label: 'Box color',
                field: 'boxcolor',
                color: _asset.boxcolor,
                size: 140),
          ],
        ),
      ),
    ]);
  }
}

class _SubMenu extends StatelessWidget {
  final directorService = locator.get<DirectorService>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(93, 86, 250, 1),
      margin: EdgeInsets.only(right: 16),
      child: Column(
        children: [
          IconButton(
            icon: Icon(Icons.text_format, color: Colors.white),
            onPressed: () {},
          ), /*
          IconButton(
            icon: Icon(Icons.aspect_ratio, color: Colors.grey.shade500),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.settings_brightness, color: Colors.grey.shade500),
            onPressed: () {},
          ), */
        ],
      ),
    );
  }
}

class _FontFamily extends StatelessWidget {
  final directorService = locator.get<DirectorService>();
  final Asset _asset;

  _FontFamily(this._asset);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      child: Row(children: [
        Text('Font:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100)),
        Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
        DropdownButton(
          value: (directorService.editingTextAsset != null)
              ? Font.getByPath(directorService.editingTextAsset.font)
              : Font.allFonts[1],
          items: Localizations.localeOf(context).languageCode == 'ur'
              ? Font.allFonts
                  .sublist(0, 2)
                  .map((Font font) => DropdownMenuItem(
                      value: font,
                      child: Text(
                        font.title,
                        style: TextStyle(
                          fontFamily: font.family,
                          fontSize: 12 / MediaQuery.of(context).textScaleFactor,
                          fontStyle: font.style,
                          fontWeight: font.weight,
                        ),
                      )))
                  .toList()
              : Font.allFonts
                  .sublist(1)
                  .map((Font font) => DropdownMenuItem(
                      value: font,
                      child: Text(
                        font.title,
                        style: TextStyle(
                          fontFamily: font.family,
                          fontSize: 12 / MediaQuery.of(context).textScaleFactor,
                          fontStyle: font.style,
                          fontWeight: font.weight,
                        ),
                      )))
                  .toList(),
          onChanged: (font) {
            Asset newAsset = Asset.clone(_asset);
            newAsset.font = font.path;
            directorService.editingTextAsset = newAsset;
          },
        ),
      ]),
    );
  }
}

class _FontSize extends StatelessWidget {
  final directorService = locator.get<DirectorService>();
  final Asset _asset;

  _FontSize(this._asset);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 235,
      child: Row(children: [
        Text('Size:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100)),
        Slider(
          inactiveColor: Color.fromRGBO(93, 86, 250, 0.3),
          activeColor: Color.fromRGBO(93, 86, 250, 1),
          thumbColor: Color.fromRGBO(93, 86, 250, 1),
          min: 0.01,
          max: 1,
          value: math.sqrt(_asset?.fontSize ?? 1),
          onChanged: (size) {
            Asset newAsset = Asset.clone(_asset);
            newAsset.fontSize = size;
            directorService.editingTextAsset = newAsset;
          },
        ),
      ]),
    );
  }
}

class _ColorField extends StatelessWidget {
  final directorService = locator.get<DirectorService>();
  final String label;
  final String field;
  final int color;
  final double size;

  _ColorField(
      {this.label = 'Color', this.field, this.color = 0, this.size = 110});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      child: Row(children: <Widget>[
        Text('$label:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100)),
        IconButton(
          icon: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Color(color),
                  border: Border.all(
                    color: Colors.grey.shade500,
                    width: 1,
                  ))),
          onPressed: () {
            directorService.editingColor = field;
          },
        ),
      ]),
    );
  }
}

class Font {
  String title;
  String family;
  FontWeight weight;
  FontStyle style;
  String path;

  Font({
    this.title,
    this.family,
    this.weight = FontWeight.w400,
    this.style = FontStyle.normal,
    this.path,
  });

  static Font getByPath(String path) {
    return allFonts.firstWhere((font) => font.path == path);
  }

  static List<Font> allFonts = [
    Font(
        title: 'Noto Sans',
        family: 'Noto Sans Arabic',
        weight: FontWeight.w700,
        path: 'Noto_Sans_Arabic/NotoSansArabic-VariableFont_wdth.ttf'),
    Font(
        title: 'Noto Naskh',
        family: 'Noto Naskh Arabic',
        weight: FontWeight.w700,
        path: 'Noto_Naskh_Arabic/NotoNaskhArabic-VariableFont_wght.ttf'),
    Font(
        title: 'Lato black',
        family: 'Lato',
        weight: FontWeight.w900,
        path: 'Lato/Lato-Black.ttf'),
    Font(
        title: 'Lato black italic',
        family: 'Lato',
        style: FontStyle.italic,
        weight: FontWeight.w900,
        path: 'Lato/Lato-BlackItalic.ttf'),
    Font(
        title: 'Lato bold',
        family: 'Lato',
        weight: FontWeight.w700,
        path: 'Lato/Lato-Bold.ttf'),
    Font(
        title: 'Lato bold italic',
        family: 'Lato',
        style: FontStyle.italic,
        weight: FontWeight.w700,
        path: 'Lato/Lato-BoldItalic.ttf'),
    Font(
        title: 'Lato light',
        family: 'Lato',
        weight: FontWeight.w300,
        path: 'Lato/Lato-Light.ttf'),
    Font(
        title: 'Lato light italic',
        family: 'Lato',
        style: FontStyle.italic,
        weight: FontWeight.w300,
        path: 'Lato/Lato-LightItalic.ttf'),
    Font(
        title: 'Lato regular',
        family: 'Lato',
        weight: FontWeight.w400,
        path: 'Lato/Lato-Regular.ttf'),
    Font(
        title: 'Lato regular italic',
        family: 'Lato',
        style: FontStyle.italic,
        weight: FontWeight.w400,
        path: 'Lato/Lato-RegularItalic.ttf'),
    Font(
        title: 'Lato thin',
        family: 'Lato',
        weight: FontWeight.w100,
        path: 'Lato/Lato-Thin.ttf'),
    Font(
        title: 'Lato thin italic',
        family: 'Lato',
        style: FontStyle.italic,
        weight: FontWeight.w100,
        path: 'Lato/Lato-ThinItalic.ttf'),
    Font(
        title: 'OpenSans bold',
        family: 'OpenSans',
        weight: FontWeight.w700,
        path: 'Open_Sans/OpenSans-Bold.ttf'),
    Font(
        title: 'OpenSans bold italic',
        family: 'OpenSans',
        style: FontStyle.italic,
        weight: FontWeight.w700,
        path: 'Open_Sans/OpenSans-BoldItalic.ttf'),
    Font(
        title: 'OpenSans extrabold',
        family: 'OpenSans',
        weight: FontWeight.w800,
        path: 'Open_Sans/OpenSans-ExtraBold.ttf'),
    Font(
        title: 'OpenSans extrabold italic',
        family: 'OpenSans',
        style: FontStyle.italic,
        weight: FontWeight.w800,
        path: 'Open_Sans/OpenSans-ExtraBoldItalic.ttf'),
    Font(
        title: 'OpenSans  italic',
        family: 'OpenSans',
        style: FontStyle.italic,
        weight: FontWeight.w400,
        path: 'Open_Sans/OpenSans-Italic.ttf'),
    Font(
        title: 'OpenSans light',
        family: 'OpenSans',
        weight: FontWeight.w300,
        path: 'Open_Sans/OpenSans-Light.ttf'),
    Font(
        title: 'OpenSans light italic',
        family: 'OpenSans',
        style: FontStyle.italic,
        weight: FontWeight.w300,
        path: 'Open_Sans/OpenSans-LightItalic.ttf'),
    Font(
        title: 'OpenSans regular',
        family: 'OpenSans',
        weight: FontWeight.w400,
        path: 'Open_Sans/OpenSans-Regular.ttf'),
    Font(
        title: 'OpenSans semibold',
        family: 'OpenSans',
        weight: FontWeight.w600,
        path: 'Open_Sans/OpenSans-SemiBold.ttf'),
    Font(
        title: 'OpenSans semibold italic',
        family: 'OpenSans',
        style: FontStyle.italic,
        weight: FontWeight.w600,
        path: 'Open_Sans/OpenSans-SemiBoldItalic.ttf'),
    Font(
        title: 'Pacifico regular',
        family: 'Pacifico',
        weight: FontWeight.w400,
        path: 'Pacifico/Pacifico-Regular.ttf'),
    Font(
        title: 'Roboto black',
        family: 'Roboto',
        weight: FontWeight.w900,
        path: 'Roboto/Roboto-Black.ttf'),
    Font(
        title: 'Roboto black italic',
        family: 'Roboto',
        style: FontStyle.italic,
        weight: FontWeight.w900,
        path: 'Roboto/Roboto-BlackItalic.ttf'),
    Font(
        title: 'Roboto bold',
        family: 'Roboto',
        weight: FontWeight.w700,
        path: 'Roboto/Roboto-Bold.ttf'),
    Font(
        title: 'Roboto bold italic',
        family: 'Roboto',
        style: FontStyle.italic,
        weight: FontWeight.w700,
        path: 'Roboto/Roboto-BoldItalic.ttf'),
    Font(
        title: 'Roboto  italic',
        family: 'Roboto',
        style: FontStyle.italic,
        weight: FontWeight.w400,
        path: 'Roboto/Roboto-Italic.ttf'),
    Font(
        title: 'Roboto light',
        family: 'Roboto',
        weight: FontWeight.w300,
        path: 'Roboto/Roboto-Light.ttf'),
    Font(
        title: 'Roboto light italic',
        family: 'Roboto',
        style: FontStyle.italic,
        weight: FontWeight.w300,
        path: 'Roboto/Roboto-LightItalic.ttf'),
    Font(
        title: 'Roboto medium',
        family: 'Roboto',
        weight: FontWeight.w500,
        path: 'Roboto/Roboto-Medium.ttf'),
    Font(
        title: 'Roboto medium italic',
        family: 'Roboto',
        style: FontStyle.italic,
        weight: FontWeight.w500,
        path: 'Roboto/Roboto-MediumItalic.ttf'),
    Font(
        title: 'Roboto regular',
        family: 'Roboto',
        weight: FontWeight.w400,
        path: 'Roboto/Roboto-Regular.ttf'),
    Font(
        title: 'Roboto regular italic',
        family: 'Roboto',
        style: FontStyle.italic,
        weight: FontWeight.w400,
        path: 'Roboto/Roboto-RegularItalic.ttf'),
    Font(
        title: 'Roboto thin',
        family: 'Roboto',
        weight: FontWeight.w100,
        path: 'Roboto/Roboto-Thin.ttf'),
    Font(
        title: 'Roboto thin italic',
        family: 'Roboto',
        style: FontStyle.italic,
        weight: FontWeight.w100,
        path: 'Roboto/Roboto-ThinItalic.ttf'),
  ];
}
