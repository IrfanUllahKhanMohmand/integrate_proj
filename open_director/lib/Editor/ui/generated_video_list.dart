import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:open_director/Editor/service_locator.dart';
import 'package:open_director/Editor/service/generated_video_service.dart';
import 'package:open_director/Editor/model/generated_video.dart';
import 'package:open_director/Editor/model/project.dart';

class GeneratedVideoList extends StatelessWidget {
  final generatedVideoService = locator.get<GeneratedVideoService>();
  final Project project;

  GeneratedVideoList(this.project) {
    generatedVideoService.refresh(project.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 40,
            ),
            Text('${project.title}'),
          ],
        ),
        backgroundColor: const Color.fromRGBO(93, 86, 250, 1),
        // actions: <Widget>[
        //   // TextButton.icon(
        //   //   label: const Text('Exit'),
        //   //   icon: const Icon(Icons.exit_to_app),
        //   //   onPressed: () {
        //   //     SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        //   //   },
        //   // ),
        // ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: Text(
              'Generated videos',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream: generatedVideoService.generatedVideoListChanged$,
                initialData: false,
                builder: (BuildContext context,
                    AsyncSnapshot<bool> generatedVideoListChanged) {
                  final List<GeneratedVideo> list =
                      generatedVideoService.generatedVideoList;
                  return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _GeneratedVideoCard(index);
                      });
                }),
          ),
        ],
      ),
    );
  }
}

class _GeneratedVideoCard extends StatelessWidget {
  final generatedVideoService = locator.get<GeneratedVideoService>();
  final int index;

  _GeneratedVideoCard(this.index) : super();

  messageFileNotExist(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('File does not exist'),
          content: Text('This video file has been deleted from your device'),
          actions: <Widget>[
            TextButton(
              child: new Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<GeneratedVideo> list = generatedVideoService.generatedVideoList;
    bool thumbnailExists = File(list[index].thumbnail).existsSync();
    return GestureDetector(
        child: Card(
          child: ListTile(
            leading: thumbnailExists
                ? Image.file(File(list[index].thumbnail))
                : null,
            title: Text('${DateFormat.yMMMMd().format(list[index].date)} '
                '${DateFormat.Hm().format(list[index].date)}'),
            subtitle: Text('${list[index].resolution}'),
            trailing: PopupMenuButton<int>(
              icon: Icon(Icons.more_vert, color: Colors.white),
              onSelected: (int result) {
                if (result == 1) {
                  if (!generatedVideoService.fileExists(index)) {
                    messageFileNotExist(context);
                  } else {
                    OpenFile.open(list[index].path);
                  }
                } else if (result == 2) {
                  generatedVideoService.delete(index);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                const PopupMenuItem<int>(value: 1, child: Text('Watch')),
                const PopupMenuDivider(height: 10),
                const PopupMenuItem<int>(value: 2, child: Text('Delete')),
              ],
            ),
          ),
        ),
        onTap: () {
          if (!generatedVideoService.fileExists(index)) {
            messageFileNotExist(context);
          } else {
            OpenFile.open(list[index].path);
          }
        });
  }
}
