import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:open_director/Editor/service_locator.dart';
import 'package:open_director/Editor/service/director_service.dart';
import 'package:open_director/Editor/ui/director/params.dart';
import 'package:open_director/Editor/model/model.dart';

class ColorEditor extends StatelessWidget {
  final directorService = locator.get<DirectorService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: directorService.editingColor$,
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot<String> editingColor) {
          if (editingColor.data == null) return Container();
          return Container(
            height: Params.getTimelineHeight(context),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  width: 2,
                  color: const Color.fromRGBO(93, 86, 250, 1),
                ),
              ),
            ),
            child: ColorForm(),
          );
        });
  }
}

class ColorForm extends StatelessWidget {
  final directorService = locator.get<DirectorService>();

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    int fontColor = 0;
    if (directorService.editingColor == 'fontColor') {
      fontColor = directorService.editingTextAsset?.fontColor;
    } else if (directorService.editingColor == 'boxcolor') {
      fontColor = directorService.editingTextAsset?.boxcolor;
    }
    return SingleChildScrollView(
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: MediaQuery.of(context).size.width - 130,
          child: Wrap(
            children: [
              Container(
                height: (MediaQuery.of(context).orientation ==
                        Orientation.landscape)
                    ? width / 4
                    : height / 2,
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                child: ColorPicker(
                  pickerColor: Color(fontColor),
                  paletteType: PaletteType.hsv,
                  enableAlpha: true,
                  colorPickerWidth: isLandscape ? width / 4 : height / 3.5,
                  pickerAreaHeightPercent: 0.8,
                  onColorChanged: (color) {
                    Asset newAsset =
                        Asset.clone(directorService.editingTextAsset);
                    if (directorService.editingColor == 'fontColor') {
                      newAsset.fontColor = color.value;
                    } else if (directorService.editingColor == 'boxcolor') {
                      newAsset.boxcolor = color.value;
                    }
                    directorService.editingTextAsset = newAsset;
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Column(children: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromRGBO(93, 86, 250, 1))),
              child: Text('SELECT'),
              onPressed: () {
                directorService.editingColor = null;
              },
            ),
          ]),
        ),
      ]),
    );
  }
}
