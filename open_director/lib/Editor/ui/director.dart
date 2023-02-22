import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_director/Editor/ui/common/volume_variables.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';
import 'package:open_director/Editor/service_locator.dart';
import 'package:open_director/Editor/service/director_service.dart';
import 'package:open_director/Editor/model/project.dart';
import 'package:open_director/Editor/model/model.dart';
import 'package:open_director/Editor/ui/director/params.dart';
import 'package:open_director/Editor/ui/director/app_bar.dart';
import 'package:open_director/Editor/ui/director/asset_selection.dart';
import 'package:open_director/Editor/ui/director/drag_closest.dart';
import 'package:open_director/Editor/ui/director/asset_sizer.dart';
import 'package:open_director/Editor/ui/director/text_asset_editor.dart';
import 'package:open_director/Editor/ui/director/color_editor.dart';
import 'package:open_director/Editor/ui/director/text_form.dart';
import 'package:open_director/Editor/ui/director/text_player_editor.dart';
import 'package:open_director/Editor/ui/common/animated_dialog.dart';

class DirectorScreen extends StatefulWidget {
  final Project project;
  const DirectorScreen(this.project, {Key key}) : super(key: key);

  @override
  _DirectorScreen createState() => _DirectorScreen(project);
}

class _DirectorScreen extends State<DirectorScreen>
    with WidgetsBindingObserver {
  final directorService = locator.get<DirectorService>();
  StreamSubscription<bool> _dialogFilesNotExistSubscription;

  _DirectorScreen(Project project) {
    directorService.setProject(project);

    _dialogFilesNotExistSubscription =
        directorService.filesNotExist$.listen((val) {
      if (val) {
        // Delayed because widgets are building
        Future.delayed(Duration(milliseconds: 100), () {
          AnimatedDialog.show(
            context,
            title: 'Some assets have been deleted',
            child: Text(
                'To continue you must recover deleted assets in your device '
                'or remove them from the timeline (marked in red).'),
            button2Text: 'OK',
            onPressedButton2: () {
              Navigator.of(context).pop();
            },
          );
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _dialogFilesNotExistSubscription.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      Params.fixHeight = true;
    } else if (state == AppLifecycleState.resumed) {
      Params.fixHeight = false;
    }
  }

  @override
  void didHaveMemoryPressure() {
    super.didHaveMemoryPressure();
    // To release memory
    imageCache.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (directorService.editingColor != null) {
          directorService.editingColor = null;
          return false;
        }
        if (directorService.editingTextAsset != null) {
          directorService.editingTextAsset = null;
          return false;
        }
        bool exit = await directorService.exitAndSaveProject();
        if (exit) Navigator.pop(context);
        return false;
      },
      child: Material(
        color: Colors.grey.shade900,
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              if (directorService.editingTextAsset == null) {
                directorService.select(-1, -1);
              }
              // Hide keyboard
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Container(
              color: Colors.grey.shade900,
              child: _Director(),
            ),
          ),
        ),
      ),
    );
  }
}

class DirectorScreenFirstTime extends StatefulWidget {
  final Project project;
  const DirectorScreenFirstTime(this.project, {Key key}) : super(key: key);

  @override
  _DirectorScreenFirstTime createState() => _DirectorScreenFirstTime(project);
}

class _DirectorScreenFirstTime extends State<DirectorScreenFirstTime>
    with WidgetsBindingObserver {
  final directorService = locator.get<DirectorService>();
  StreamSubscription<bool> _dialogFilesNotExistSubscription;

  _DirectorScreenFirstTime(Project project) {
    directorService.setProjectFirstTime(project);

    _dialogFilesNotExistSubscription =
        directorService.filesNotExist$.listen((val) {
      if (val) {
        // Delayed because widgets are building
        Future.delayed(Duration(milliseconds: 100), () {
          AnimatedDialog.show(
            context,
            title: 'Some assets have been deleted',
            child: Text(
                'To continue you must recover deleted assets in your device '
                'or remove them from the timeline (marked in red).'),
            button2Text: 'OK',
            onPressedButton2: () {
              Navigator.of(context).pop();
            },
          );
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _dialogFilesNotExistSubscription.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      Params.fixHeight = true;
    } else if (state == AppLifecycleState.resumed) {
      Params.fixHeight = false;
    }
  }

  @override
  void didHaveMemoryPressure() {
    super.didHaveMemoryPressure();
    // To release memory
    imageCache.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (directorService.editingColor != null) {
          directorService.editingColor = null;
          return false;
        }
        if (directorService.editingTextAsset != null) {
          directorService.editingTextAsset = null;
          return false;
        }
        bool exit = await directorService.exitAndSaveProject();
        if (exit) Navigator.pop(context);
        return false;
      },
      child: Material(
        color: const Color.fromRGBO(245, 245, 247, 1),
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              if (directorService.editingTextAsset == null) {
                directorService.select(-1, -1);
              }
              // Hide keyboard
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Container(
              color: const Color.fromRGBO(245, 245, 247, 1),
              child: _Director(),
            ),
          ),
        ),
      ),
    );
  }
}

class _Director extends StatelessWidget {
  final directorService = locator.get<DirectorService>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: Params.getPlayerHeight(context) +
              (MediaQuery.of(context).orientation == Orientation.landscape
                  ? 0
                  : Params.APP_BAR_HEIGHT * 2),
          child: MediaQuery.of(context).orientation == Orientation.landscape
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                      AppBar1(),
                      _Video(),
                      AppBar2(),
                    ])
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                      AppBar1(),
                      _Video(),
                      AppBar2(),
                    ]),
        ),
        Stack(
          alignment: const Alignment(0, -1),
          children: <Widget>[
            SingleChildScrollView(
              child: Stack(
                alignment: const Alignment(-1, -1),
                children: <Widget>[
                  Container(
                    color: Color.fromARGB(255, 226, 225, 225),
                    child: GestureDetector(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollState) {
                          if (scrollState is ScrollEndNotification) {
                            directorService.endScroll();
                          }
                          return false;
                        },
                        child: _TimeLine(),
                      ),
                      onScaleStart: (ScaleStartDetails details) {
                        directorService.scaleStart();
                      },
                      onScaleUpdate: (ScaleUpdateDetails details) {
                        directorService.scaleUpdate(details.horizontalScale);
                      },
                      onScaleEnd: (ScaleEndDetails details) {
                        directorService.scaleEnd();
                      },
                    ),
                  ),
                  _LayerHeaders(),
                ],
              ),
            ),
            _PositionLine(),
            _PositionMarker(),
            TextAssetEditor(),
            ColorEditor(),
          ],
        ),
      ],
    );
  }
}

class _PositionLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 2,
        height: Params.getTimelineHeight(context) - 4,
        margin: EdgeInsets.fromLTRB(0, 2, 0, 2),
        color: const Color.fromRGBO(130, 130, 130, 1));
  }
}

class _PositionMarker extends StatelessWidget {
  final directorService = locator.get<DirectorService>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: Params.RULER_HEIGHT - 4,
      margin: EdgeInsets.fromLTRB(0, 2, 0, 2),
      color: const Color.fromRGBO(93, 86, 250, 1),
      child: StreamBuilder(
          stream: directorService.position$,
          initialData: 0,
          builder: (BuildContext context, AsyncSnapshot<int> position) {
            return Center(
                child: Text(
                    '${directorService.positionMinutes}:${directorService.positionSeconds}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    )));
          }),
    );
  }
}

class _TimeLine extends StatelessWidget {
  final directorService = locator.get<DirectorService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: directorService.layersChanged$,
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot<bool> layersChanged) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: directorService.scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Ruler(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: directorService.layers
                      .asMap()
                      .map((index, layer) =>
                          MapEntry(index, _LayerAssets(index)))
                      .values
                      .toList(),
                ),
                Container(
                  height: Params.getLayerBottom(context),
                ),
              ],
            ),
          );
        });
  }
}

class _Ruler extends StatelessWidget {
  final directorService = locator.get<DirectorService>();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RulerPainter(context),
      child: Container(
        // color: const Color.fromRGBO(245, 245, 247, 1),
        height: Params.RULER_HEIGHT - 4,
        width: MediaQuery.of(context).size.width +
            directorService.pixelsPerSecond * directorService.duration / 1000,
        margin: const EdgeInsets.fromLTRB(0, 2, 0, 2),
      ),
    );
  }
}

class RulerPainter extends CustomPainter {
  final directorService = locator.get<DirectorService>();
  final BuildContext context;

  RulerPainter(this.context);

  getSecondsPerDivision(double pixPerSec) {
    if (pixPerSec > 40) {
      return 1;
    } else if (pixPerSec > 20) {
      return 2;
    } else if (pixPerSec > 10) {
      return 5;
    } else if (pixPerSec > 4) {
      return 10;
    } else if (pixPerSec > 1.5) {
      return 30;
    } else {
      return 60;
    }
  }

  getTimeText(int seconds) {
    return '${(seconds / 60).floor() < 10 ? '0' : ''}'
        '${(seconds / 60).floor()}'
        '.${seconds - (seconds / 60).floor() * 60 < 10 ? '0' : ''}'
        '${seconds - (seconds / 60).floor() * 60}';
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double width =
        directorService.duration / 1000 * directorService.pixelsPerSecond +
            MediaQuery.of(context).size.width;

    final paint = Paint();
    paint.color = const Color.fromRGBO(245, 245, 247, 1);
    Rect rect = Rect.fromLTWH(0, 2, width, size.height - 4);
    canvas.drawRect(rect, paint);

    paint.color = const Color.fromRGBO(130, 130, 130, 1);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;

    Path path = Path();
    path.moveTo(0, size.height - 2);
    path.relativeLineTo(width, 0);
    path.close();
    canvas.drawPath(path, paint);

    int secondsPerDivision =
        getSecondsPerDivision(directorService.pixelsPerSecond);
    final double pixelsPerDivision =
        secondsPerDivision * directorService.pixelsPerSecond;
    final int numberOfDivisions =
        ((width - MediaQuery.of(context).size.width / 2) / pixelsPerDivision)
            .floor();

    for (int i = 0; i <= numberOfDivisions; i++) {
      int seconds = i * secondsPerDivision;
      String text = getTimeText(seconds);

      final TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
        text: TextSpan(
          text: text,
          style: const TextStyle(
            color: Color.fromRGBO(130, 130, 130, 1),
            fontSize: 10,
          ),
        ),
      );

      textPainter.layout();
      double x = MediaQuery.of(context).size.width / 2 + i * pixelsPerDivision;
      textPainter.paint(canvas, Offset(x + 6, 6));

      Path path = Path();
      path.moveTo(x + 1, size.height - 4);
      path.relativeLineTo(0, -8);
      path.moveTo(x + 1 + 0.5 * pixelsPerDivision, size.height - 4);
      path.relativeLineTo(0, -2);
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _LayerHeaders extends StatefulWidget {
  @override
  State<_LayerHeaders> createState() => _LayerHeadersState();
}

class _LayerHeadersState extends State<_LayerHeaders> {
  final directorService = locator.get<DirectorService>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: Params.RULER_HEIGHT - 4,
          width: 33,
          color: Colors.transparent,
          margin: EdgeInsets.fromLTRB(0, 2, 0, 2),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: directorService.layers
              .asMap()
              .map((index, layer) => MapEntry(
                  index,
                  Row(
                    children: [
                      _LayerHeader(layer.type),
                      layer.type == 'raster'
                          ? VolumeVariables.isMute
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      VolumeVariables.isMute =
                                          !VolumeVariables.isMute;
                                    });
                                  },
                                  child: Icon(
                                    Icons.volume_off_outlined,
                                    color: Color.fromARGB(255, 80, 80, 80),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      VolumeVariables.isMute =
                                          !VolumeVariables.isMute;
                                    });
                                  },
                                  child: Icon(
                                    Icons.volume_up,
                                    color: Color.fromARGB(255, 80, 80, 80),
                                  ),
                                )
                          : Container(),
                    ],
                  )))
              .values
              .toList(),
        ),
      ],
    );
  }
}

class _Video extends StatelessWidget {
  final directorService = locator.get<DirectorService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: directorService.position$,
        builder: (BuildContext context, AsyncSnapshot<int> position) {
          var backgroundContainer = Container(
            color: const Color.fromRGBO(245, 245, 247, 1),
            height: Params.getPlayerHeight(context),
            width: Params.getPlayerWidth(context),
          );
          if (directorService.layerPlayers == null ||
              directorService.layerPlayers.length == 0) {
            return backgroundContainer;
          }
          int assetIndex = directorService.layerPlayers[0].currentAssetIndex;
          if (assetIndex == -1 ||
              assetIndex >= directorService.layers[0].assets.length) {
            return backgroundContainer;
          }
          AssetType type = directorService.layers[0].assets[assetIndex].type;
          return Container(
            height: Params.getPlayerHeight(context),
            width: Params.getPlayerWidth(context),
            child: Stack(
              children: [
                backgroundContainer,
                (type == AssetType.video)
                    ? VideoPlayer(
                        directorService.layerPlayers[0].videoController)
                    : _ImagePlayer(
                        directorService.layers[0].assets[assetIndex]),
                _TextPlayer(),
              ],
            ),
          );
        });
  }
}

class _ImagePlayer extends StatelessWidget {
  final directorService = locator.get<DirectorService>();
  final Asset asset;

  _ImagePlayer(this.asset) : super();

  @override
  Widget build(BuildContext context) {
    if (asset.deleted) return Container();
    return StreamBuilder(
        stream: directorService.position$,
        initialData: 0,
        builder: (BuildContext context, AsyncSnapshot<int> position) {
          int assetIndex = directorService.layerPlayers[0].currentAssetIndex;
          double ratio = (directorService.position -
                  directorService.layers[0].assets[assetIndex].begin) /
              directorService.layers[0].assets[assetIndex].duration;
          if (ratio < 0) ratio = 0;
          if (ratio > 1) ratio = 1;
          return KenBurnEffect(
            asset.thumbnailMedPath ?? asset.srcPath,
            ratio,
            zSign: asset.kenBurnZSign,
            xTarget: asset.kenBurnXTarget,
            yTarget: asset.kenBurnYTarget,
          );
        });
  }
}

class KenBurnEffect extends StatelessWidget {
  final String path;
  final double ratio;
  // Effect configuration
  final int zSign;
  final double xTarget;
  final double yTarget;

  KenBurnEffect(
    this.path,
    this.ratio, {
    this.zSign = 0, // Options: {-1, 0, +1}
    this.xTarget = 0, // Options: {0, 0.5, 1}
    this.yTarget = 0, // Options; {0, 0.5, 1}
  }) : super();

  @override
  Widget build(BuildContext context) {
    // Start and end positions
    double xStart = (zSign == 1) ? 0 : (0.5 - xTarget);
    double xEnd =
        (zSign == 1) ? (0.5 - xTarget) : ((zSign == -1) ? 0 : (xTarget - 0.5));
    double yStart = (zSign == 1) ? 0 : (0.5 - yTarget);
    double yEnd =
        (zSign == 1) ? (0.5 - yTarget) : ((zSign == -1) ? 0 : (yTarget - 0.5));
    double zStart = (zSign == 1) ? 0 : 1;
    double zEnd = (zSign == -1) ? 0 : 1;

    // Interpolation
    double x = xStart * (1 - ratio) + xEnd * ratio;
    double y = yStart * (1 - ratio) + yEnd * ratio;
    double z = zStart * (1 - ratio) + zEnd * ratio;

    return LayoutBuilder(builder: (context, constraints) {
      return ClipRect(
        child: Transform.translate(
          offset: Offset(x * 0.2 * Params.getPlayerWidth(context),
              y * 0.2 * Params.getPlayerHeight(context)),
          child: Transform.scale(
            scale: 1 + z * 0.2,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(File(path)),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _TextPlayer extends StatelessWidget {
  final directorService = locator.get<DirectorService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: directorService.editingTextAsset$,
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot<Asset> editingTextAsset) {
          Asset _asset = editingTextAsset.data;
          if (_asset == null) {
            _asset = directorService.getAssetByPosition(1);
          }
          if (_asset == null || _asset.type != AssetType.text) {
            return Container();
          }
          Font font = Font.getByPath(_asset.font);
          return Positioned(
            left: _asset.x * Params.getPlayerWidth(context),
            top: _asset.y * Params.getPlayerHeight(context),
            child: Container(
              child: (directorService.editingTextAsset == null)
                  ? Text(
                      _asset.title,
                      /*strutStyle: StrutStyle(
                        fontSize: _asset.fontSize *
                            Params.getPlayerWidth(context) /
                            MediaQuery.of(context).textScaleFactor,
                        fontStyle: font.style,
                        fontFamily: font.family,
                        fontWeight: font.weight,
                        height: 1,
                        leading: 0.0,
                      ),*/
                      style: TextStyle(
                        height: 1,
                        fontSize: _asset.fontSize *
                            Params.getPlayerWidth(context) /
                            MediaQuery.of(context).textScaleFactor,
                        fontStyle: font.style,
                        fontFamily: font.family,
                        fontWeight: font.weight,
                        color: Color(_asset.fontColor),
                        backgroundColor: Color(_asset.boxcolor),
                      ),
                    )
                  : TextPlayerEditor(editingTextAsset.data),
            ),
          );
        });
  }
}

class _LayerHeader extends StatelessWidget {
  final String type;
  _LayerHeader(this.type) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Params.getLayerHeight(context, type),
        width: 28.0,
        margin: const EdgeInsets.fromLTRB(0, 1, 1, 1),
        padding: const EdgeInsets.all(4.0),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(130, 130, 130, 1),
        ),
        child: Icon(
          type == "raster"
              ? Icons.photo
              : type == "vector"
                  ? Icons.text_fields
                  : Icons.music_note,
          color: Colors.white,
          size: 16,
        ));
  }
}

class _LayerAssets extends StatelessWidget {
  final directorService = locator.get<DirectorService>();
  final int layerIndex;
  _LayerAssets(this.layerIndex) : super();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: const Alignment(0, 0),
      children: [
        Container(
          height: Params.getLayerHeight(
              context, directorService.layers[layerIndex].type),
          margin: EdgeInsets.all(1),
          child: Row(
            children: [
              // Half left screen in blank
              Container(width: MediaQuery.of(context).size.width / 2),

              Row(
                children: directorService.layers[layerIndex].assets.isNotEmpty
                    ? directorService.layers[layerIndex].assets
                        .asMap()
                        .map((assetIndex, asset) => MapEntry(
                              assetIndex,
                              _Asset(layerIndex, assetIndex),
                            ))
                        .values
                        .toList()
                    : [_AssetSelect(layerIndex)],
              ),
              directorService.layers[layerIndex].assets.isNotEmpty
                  ? _AssetAdd(layerIndex)
                  : Container(),
              Container(
                width: MediaQuery.of(context).size.width / 2 - 2,
              ),
            ],
          ),
        ),
        AssetSelection(layerIndex),
        AssetSizer(layerIndex, false),
        AssetSizer(layerIndex, true),
        (layerIndex != 1) ? DragClosest(layerIndex) : Container(),
      ],
    );
  }
}

class _Asset extends StatefulWidget {
  final int layerIndex;
  final int assetIndex;
  _Asset(this.layerIndex, this.assetIndex) : super();

  @override
  State<_Asset> createState() => _AssetState();
}

class _AssetState extends State<_Asset> {
  final directorService = locator.get<DirectorService>();
  double value1 = 0.5;
  double value2 = 0.5;
  @override
  Widget build(BuildContext context) {
    Asset asset =
        directorService.layers[widget.layerIndex].assets[widget.assetIndex];
    Color backgroundColor = Colors.transparent;
    Color borderColor = Colors.transparent;
    Color textColor = Colors.transparent;
    Color backgroundTextColor = Colors.transparent;
    if (asset.deleted) {
      backgroundColor = Colors.red.shade200;
      borderColor = Colors.red;
      textColor = Colors.red.shade900;
    } else if (widget.layerIndex == 0) {
      backgroundColor = const Color.fromRGBO(245, 245, 247, 1);
      borderColor = const Color.fromRGBO(93, 86, 250, 1);
      textColor = Colors.white;
      backgroundTextColor = Colors.black.withOpacity(0.5);
    } else if (widget.layerIndex == 1 && asset.title != '') {
      backgroundColor = const Color.fromRGBO(245, 245, 247, 1);
      borderColor = const Color.fromRGBO(93, 86, 250, 1);
      textColor = const Color.fromRGBO(130, 130, 130, 1);
    } else if (widget.layerIndex == 2) {
      backgroundColor = const Color.fromRGBO(245, 245, 247, 1);
      borderColor = const Color.fromRGBO(93, 86, 250, 1);
      textColor = const Color.fromRGBO(130, 130, 130, 1);
    }
    return GestureDetector(
      child: Container(
        height: Params.getLayerHeight(
            context, directorService.layers[widget.layerIndex].type),
        child: Text(
          asset.title,
          style: TextStyle(
              color: textColor,
              fontSize: 12,
              backgroundColor: backgroundTextColor,
              shadows: <Shadow>[
                Shadow(
                    color: Colors.black,
                    offset:
                        (widget.layerIndex == 0) ? Offset(1, 1) : Offset(0, 0))
              ]),
        ),
        width: asset.duration * directorService.pixelsPerSecond / 1000.0,
        padding: const EdgeInsets.fromLTRB(4, 3, 4, 3),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            top: BorderSide(width: 2, color: borderColor),
            bottom: BorderSide(width: 2, color: borderColor),
            left: BorderSide(
                width: (widget.assetIndex == 0) ? 1 : 0, color: borderColor),
            right: BorderSide(width: 1, color: borderColor),
          ),
          image: (!asset.deleted &&
                  asset.thumbnailPath != null &&
                  !directorService.isGenerating)
              ? DecorationImage(
                  opacity: 1,
                  image: FileImage(File(asset.thumbnailPath)),
                  fit: BoxFit.cover,
                  alignment: Alignment.topLeft,
                  //repeat: ImageRepeat.repeatX // Doesn't work with fitHeight
                )
              : null,
        ),
      ),
      onDoubleTap: () {
        if (widget.layerIndex == 0) {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (context, setState) {
                return Container(
                  height: 100,
                  color: Colors.black,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Slider(
                          value: VolumeVariables.videoVolume,
                          min: 0.0,
                          max: 1.0,
                          // divisions: 5,
                          label: VolumeVariables.videoVolume.toString(),
                          onChanged: (values) {
                            VolumeVariables.videoVolume = values;
                            setState(() {});
                          },
                        ),
                        ElevatedButton(
                          child: const Text('Set Video Volume'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          );
        }

        if (widget.layerIndex == 2) {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (context, setState) {
                return Container(
                  height: 100,
                  color: Colors.black,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Slider(
                          value: VolumeVariables.audioVolume,
                          min: 0.0,
                          max: 1.0,
                          // divisions: 5,
                          label: VolumeVariables.audioVolume.toString(),

                          onChanged: (values) {
                            VolumeVariables.audioVolume = values;
                            setState(() {});
                          },
                        ),
                        ElevatedButton(
                          child: const Text('Set Audio Volume'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          );
        }
      },
      onTap: () {
        directorService.select(widget.layerIndex, widget.assetIndex);
      },
      onLongPressStart: (LongPressStartDetails details) {
        directorService.dragStart(widget.layerIndex, widget.assetIndex);
      },
      onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
        directorService.dragSelected(widget.layerIndex, widget.assetIndex,
            details.offsetFromOrigin.dx, MediaQuery.of(context).size.width);
      },
      onLongPressEnd: (LongPressEndDetails details) {
        directorService.dragEnd();
      },
    );
  }
}

class _AssetSelect extends StatefulWidget {
  final int layerIndex;
  _AssetSelect(this.layerIndex) : super();

  @override
  State<_AssetSelect> createState() => _AssetSelectState();
}

class _AssetSelectState extends State<_AssetSelect> {
  final directorService = locator.get<DirectorService>();
  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.white;
    Color textColor = const Color.fromRGBO(130, 130, 130, 1);
    Color backgroundTextColor = Colors.transparent;

    return GestureDetector(
      child: Container(
        height: Params.getLayerHeight(
            context, directorService.layers[widget.layerIndex].type),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.add,
              color: textColor,
            ),
            Text(
              widget.layerIndex == 0
                  ? 'Add Media'
                  : widget.layerIndex == 1
                      ? 'Add Text'
                      : widget.layerIndex == 2
                          ? 'Add Audio'
                          : '',
              style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  backgroundColor: backgroundTextColor,
                  shadows: <Shadow>[
                    Shadow(color: Colors.black, offset: Offset(0, 0))
                  ]),
            ),
          ],
        ),
        width: 10000 * directorService.pixelsPerSecond / 1000.0,
        padding: const EdgeInsets.fromLTRB(4, 3, 4, 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: backgroundColor,
          image: null,
        ),
      ),
      onTap: () {
        widget.layerIndex == 0
            ? showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0)), //this right here
                    child: Container(
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                directorService.add(AssetType.image);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.image_outlined, size: 50),
                                  Text('Image')
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                directorService.add(AssetType.video);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.video_file_outlined, size: 50),
                                  Text('Video')
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                })
            : widget.layerIndex == 1
                ? directorService.add(AssetType.text)
                : widget.layerIndex == 2
                    ? directorService.add(AssetType.audio)
                    : () {};
        // directorService.select(widget.layerIndex, widget.assetIndex);
      },
    );
  }
}

class _AssetAdd extends StatefulWidget {
  final int layerIndex;
  _AssetAdd(this.layerIndex) : super();

  @override
  State<_AssetAdd> createState() => _AssetAddState();
}

class _AssetAddState extends State<_AssetAdd> {
  final directorService = locator.get<DirectorService>();
  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Color.fromRGBO(93, 86, 250, 1);
    Color textColor = Colors.white;

    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Container(
          height: 30,
          child: Icon(
            Icons.add,
            color: textColor,
          ),
          width: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: backgroundColor,
          ),
        ),
      ),
      onTap: () {
        widget.layerIndex == 0
            ? showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0)), //this right here
                    child: Container(
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                directorService.add(AssetType.image);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.image_outlined, size: 50),
                                  Text('Image')
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                directorService.add(AssetType.video);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.video_file_outlined, size: 50),
                                  Text('Video')
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                })
            : widget.layerIndex == 1
                ? directorService.add(AssetType.text)
                : widget.layerIndex == 2
                    ? directorService.add(AssetType.audio)
                    : () {};
        // directorService.select(widget.layerIndex, widget.assetIndex);
      },
    );
  }
}
