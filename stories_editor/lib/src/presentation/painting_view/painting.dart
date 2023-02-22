import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perfect_freehand/perfect_freehand.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/domain/models/painting_model.dart';
import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/painting_notifier.dart';
import 'package:stories_editor/src/presentation/painting_view/widgets/sketcher.dart';
import 'package:stories_editor/src/presentation/painting_view/widgets/top_painting_tools.dart';
import 'package:stories_editor/src/presentation/widgets/color_selector.dart';
import 'package:stories_editor/src/presentation/widgets/size_slider_selector.dart';

class Painting extends StatefulWidget {
  const Painting({Key? key}) : super(key: key);

  @override
  State<Painting> createState() => _PaintingState();
}

class _PaintingState extends State<Painting> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PaintingNotifier>(context, listen: false)
        ..linesStreamController =
            StreamController<List<PaintingModel>>.broadcast()
        ..currentLineStreamController =
            StreamController<PaintingModel>.broadcast();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// instance of painting model
    PaintingModel? line;

    /// screen size
    var screenSize = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

    /// on gestures start
    void _onPanStart(DragStartDetails details,
        PaintingNotifier paintingNotifier, ControlNotifier controlProvider) {
      final box = context.findRenderObject() as RenderBox;
      final offset = box.globalToLocal(details.globalPosition);
      final point = Point(offset.dx, offset.dy);
      final points = [point];

      /// validate allow pan area
      if (point.y >= 40 &&
          point.y <=
              (Platform.isIOS
                  ? (screenSize.size.height - 132) - screenSize.viewPadding.top
                  : screenSize.size.height - 132)) {
        line = PaintingModel(
            points,
            paintingNotifier.lineWidth,
            1,
            1,
            false,
            controlProvider.colorList![paintingNotifier.lineColor],
            1,
            true,
            paintingNotifier.paintingType);
      }
    }

    /// on gestures update
    void _onPanUpdate(DragUpdateDetails details,
        PaintingNotifier paintingNotifier, ControlNotifier controlNotifier) {
      final box = context.findRenderObject() as RenderBox;
      final offset = box.globalToLocal(details.globalPosition);
      final point = Point(offset.dx, offset.dy);
      final points = line != null ? [...line!.points, point] : [point];

      /// validate allow pan area
      if (point.y >= 40 &&
          point.y <=
              (Platform.isIOS
                  ? (screenSize.size.height - 132) - screenSize.viewPadding.top
                  : screenSize.size.height - 132)) {
        line = PaintingModel(
            points,
            paintingNotifier.lineWidth,
            1,
            1,
            false,
            controlNotifier.colorList![paintingNotifier.lineColor],
            1,
            true,
            paintingNotifier.paintingType);
        paintingNotifier.currentLineStreamController.add(line!);
      }
    }

    /// on gestures end
    void _onPanEnd(DragEndDetails details, PaintingNotifier paintingNotifier) {
      paintingNotifier.lines = line != null
          ? (List.from(paintingNotifier.lines)..add(line!))
          : List.from(paintingNotifier.lines);
      line = null;
      paintingNotifier.linesStreamController.add(paintingNotifier.lines);
    }

    /// paint current line
    Widget _renderCurrentLine(BuildContext context,
        PaintingNotifier paintingNotifier, ControlNotifier controlNotifier) {
      return GestureDetector(
        onPanStart: (details) {
          _onPanStart(details, paintingNotifier, controlNotifier);
        },
        onPanUpdate: (details) {
          _onPanUpdate(details, paintingNotifier, controlNotifier);
        },
        onPanEnd: (details) {
          _onPanEnd(details, paintingNotifier);
        },
        child: RepaintBoundary(
          child: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: Platform.isIOS
                      ? (screenSize.size.height - 132) -
                          screenSize.viewPadding.top
                      : MediaQuery.of(context).size.height - 132,
                  child: StreamBuilder<PaintingModel>(
                      stream:
                          paintingNotifier.currentLineStreamController.stream,
                      builder: (context, snapshot) {
                        return CustomPaint(
                          painter: Sketcher(
                            lines: line == null ? [] : [line!],
                          ),
                        );
                      })),
            ),
          ),
        ),
      );
    }

    /// return Painting board
    return Consumer2<ControlNotifier, PaintingNotifier>(
      builder: (context, controlNotifier, paintingNotifier, child) {
        return WillPopScope(
          onWillPop: () async {
            controlNotifier.isPainting = false;
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              paintingNotifier.closeConnection();
            });
            return true;
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                /// render current line
                _renderCurrentLine(context, paintingNotifier, controlNotifier),

                /// select line width
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 140),
                    child: SizeSliderWidget(),
                  ),
                ),

                /// top painting tools
                // const SafeArea(child: TopPaintingTools()),

                /// bottom painting tools
                paintingNotifier.isPenPick
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 30.h, horizontal: 30.w),
                            child: const TopPaintingTools()),
                      )
                    : Container(),

                /// bottom color picker
                paintingNotifier.isColorPick
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 30.h, horizontal: 30.w),
                          child: const ColorSelector(),
                        ),
                      )
                    : Container(),
                Positioned(
                  bottom: 60,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          paintingNotifier.lines.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    paintingNotifier.removeLast();
                                  },
                                  onLongPress: () {
                                    paintingNotifier.clearAll();
                                  },
                                  child: const Icon(Icons.undo))
                              : const SizedBox(width: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 10),
                              GestureDetector(
                                  onTap: () {
                                    paintingNotifier.isPenPick = true;
                                    paintingNotifier.isColorPick = false;
                                  },
                                  child: const Icon(Icons.edit_outlined)),
                              const SizedBox(width: 15),
                              GestureDetector(
                                  onTap: () {
                                    paintingNotifier.isPenPick = false;
                                    paintingNotifier.isColorPick = true;
                                  },
                                  child: const Icon(Icons.color_lens_rounded)),
                              const SizedBox(width: 10),
                            ],
                          ),
                          GestureDetector(
                              onTap: () {
                                controlNotifier.isPainting =
                                    !controlNotifier.isPainting;
                                paintingNotifier.resetDefaults();
                              },
                              child: const Icon(Icons.check))
                        ],
                      ),
                    ),
                    decoration: const BoxDecoration(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
