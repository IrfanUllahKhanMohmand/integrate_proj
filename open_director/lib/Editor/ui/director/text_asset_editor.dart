import 'dart:core';
import 'package:flutter/material.dart';
import 'package:open_director/Editor/service_locator.dart';
import 'package:open_director/Editor/service/director_service.dart';
import 'package:open_director/Editor/model/model.dart';
import 'package:open_director/Editor/ui/director/params.dart';
import 'package:open_director/Editor/ui/director/text_form.dart';

class TextAssetEditor extends StatelessWidget {
  final directorService = locator.get<DirectorService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: directorService.editingTextAsset$,
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot<Asset> editingTextAsset) {
          if (editingTextAsset.data == null) return Container();
          return Container(
            height: Params.getTimelineHeight(context),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              border: Border(
                top: BorderSide(width: 2, color: Colors.blue),
              ),
            ),
            child: TextForm(editingTextAsset.data),
          );
        });
  }
}
