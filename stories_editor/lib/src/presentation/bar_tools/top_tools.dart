import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/domain/models/editable_items.dart';
import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/painting_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/scroll_notifier.dart';
import 'package:stories_editor/src/presentation/utils/constants/app_enums.dart';
import 'package:stories_editor/src/presentation/widgets/tool_button.dart';

class TopTools extends StatefulWidget {
  final GlobalKey contentKey;
  final BuildContext context;
  const TopTools({Key? key, required this.contentKey, required this.context})
      : super(key: key);

  @override
  _TopToolsState createState() => _TopToolsState();
}

class _TopToolsState extends State<TopTools> {
  @override
  Widget build(BuildContext context) {
    return Consumer4<ControlNotifier, PaintingNotifier, DraggableWidgetNotifier,
        ScrollNotifier>(
      builder: (_, controlNotifier, paintingNotifier, itemNotifier,
          scrollNotifier, __) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.w),
            decoration: const BoxDecoration(color: Colors.transparent),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// close button
                  // ToolButton(
                  //     child: const Icon(
                  //       Icons.close,
                  //       color: Color.fromRGBO(93, 86, 250, 1),
                  //     ),
                  //     backGroundColor: Colors.white,
                  //     colorBorder: const Color.fromRGBO(93, 86, 250, 1),
                  //     onTap: () async {
                  //       var res = await exitDialog(
                  //           context: widget.context,
                  //           contentKey: widget.contentKey);
                  //       if (res) {
                  //         Navigator.pop(context);
                  //       }
                  //     }),
                  ToolButton(
                      child: const ImageIcon(
                        AssetImage('assets/icons/overlay.png',
                            package: 'stories_editor'),
                        color: Color.fromRGBO(93, 86, 250, 1),
                        size: 20,
                      ),
                      backGroundColor: Colors.white,
                      onTap: () {}),
                  ToolButton(
                      child: const ImageIcon(
                        AssetImage('assets/icons/colorpick.png',
                            package: 'stories_editor'),
                        color: Color.fromRGBO(93, 86, 250, 1),
                        size: 20,
                      ),
                      backGroundColor: Colors.transparent,
                      onTap: () {
                        if (controlNotifier.gradientIndex >=
                            controlNotifier.gradientColors!.length - 1) {
                          setState(() {
                            controlNotifier.gradientIndex = 0;
                          });
                        } else {
                          setState(() {
                            controlNotifier.gradientIndex += 1;
                          });
                        }
                      }),
                  ToolButton(
                      child: const ImageIcon(
                        AssetImage('assets/icons/text.png',
                            package: 'stories_editor'),
                        color: Color.fromRGBO(93, 86, 250, 1),
                        size: 20,
                      ),
                      backGroundColor: Colors.white,
                      onTap: () {
                        controlNotifier.isTextEditing =
                            !controlNotifier.isTextEditing;
                        controlNotifier.isOpacityChanging = false;
                      }),
                  ToolButton(
                      child: const ImageIcon(
                        AssetImage('assets/icons/doodle.png',
                            package: 'stories_editor'),
                        color: Color.fromRGBO(93, 86, 250, 1),
                        size: 20,
                      ),
                      backGroundColor: Colors.white,
                      onTap: () {
                        controlNotifier.isPainting = true;
                        controlNotifier.isOpacityChanging = false;
                      }),
                  if (controlNotifier.mediaPath.isNotEmpty)
                    ToolButton(
                        child: const ImageIcon(
                          AssetImage('assets/icons/crop.png',
                              package: 'stories_editor'),
                          color: Color.fromRGBO(93, 86, 250, 1),
                          size: 20,
                        ),
                        backGroundColor: Colors.white,
                        onTap: () async {
                          controlNotifier.isOpacityChanging = false;
                          CroppedFile? croppedFile =
                              await ImageCropper().cropImage(
                            sourcePath: controlNotifier.mediaPath,
                            aspectRatioPresets: Platform.isAndroid
                                ? [
                                    CropAspectRatioPreset.square,
                                    CropAspectRatioPreset.ratio3x2,
                                    CropAspectRatioPreset.original,
                                    CropAspectRatioPreset.ratio4x3,
                                    CropAspectRatioPreset.ratio16x9
                                  ]
                                : [
                                    CropAspectRatioPreset.original,
                                    CropAspectRatioPreset.square,
                                    CropAspectRatioPreset.ratio3x2,
                                    CropAspectRatioPreset.ratio4x3,
                                    CropAspectRatioPreset.ratio5x3,
                                    CropAspectRatioPreset.ratio5x4,
                                    CropAspectRatioPreset.ratio7x5,
                                    CropAspectRatioPreset.ratio16x9
                                  ],
                            uiSettings: [
                              AndroidUiSettings(
                                  toolbarTitle: Localizations.localeOf(context)
                                              .languageCode ==
                                          'ur'
                                      ? 'تصویر کو تراشیں'
                                      : 'Crop Image',
                                  toolbarColor: Colors.grey,
                                  statusBarColor:
                                      const Color.fromRGBO(93, 86, 250, 1),
                                  backgroundColor:
                                      const Color.fromRGBO(245, 245, 247, 1),
                                  toolbarWidgetColor: Colors.white,
                                  // initAspectRatio: CropAspectRatioPreset.original,
                                  hideBottomControls: true,
                                  lockAspectRatio: false),
                              IOSUiSettings(
                                title: 'Cropper',
                              ),
                              WebUiSettings(
                                context: context,
                              ),
                            ],
                          );

                          controlNotifier.mediaPath =
                              croppedFile!.path.toString();
                          // controlNotifier.mediaPath = path.first.path!.toString();
                          if (controlNotifier.mediaPath.isNotEmpty) {
                            itemNotifier.draggableWidget.removeAt(0);
                            itemNotifier.draggableWidget.insert(
                                0,
                                EditableItem()
                                  ..type = ItemType.image
                                  ..position = const Offset(0.0, 0));
                          }
                          scrollNotifier.pageController.animateToPage(0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn);
                        }),
                  if (controlNotifier.mediaPath.isNotEmpty)
                    ToolButton(
                        child: const Icon(
                          size: 30,
                          Icons.delete,
                          color: Color.fromRGBO(93, 86, 250, 1),
                        ),
                        backGroundColor: Colors.white,
                        onTap: () {
                          controlNotifier.mediaPath = '';
                          itemNotifier.draggableWidget.removeAt(0);
                          controlNotifier.isOpacityChanging = false;
                        }),
                  ToolButton(
                      child: const ImageIcon(
                        AssetImage('assets/icons/onlineimage.png',
                            package: 'stories_editor'),
                        color: Color.fromRGBO(93, 86, 250, 1),
                        size: 20,
                      ),
                      backGroundColor: Colors.white,
                      onTap: () {
                        scrollNotifier.pageController.animateToPage(2,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease);

                        // if (controlNotifier.mediaPath.isEmpty) {
                        //   scrollNotifier.pageController.animateToPage(2,
                        //       duration: const Duration(milliseconds: 300),
                        //       curve: Curves.ease);
                        // }
                      }),
                  ToolButton(
                      child: const ImageIcon(
                        AssetImage('assets/icons/localimages.png',
                            package: 'stories_editor'),
                        color: Color.fromRGBO(93, 86, 250, 1),
                        size: 20,
                      ),
                      backGroundColor: Colors.white,
                      onTap: () {
                        /// scroll to gridView page
                        // if (controlNotifier.mediaPath.isEmpty) {
                        //   scrollNotifier.pageController.animateToPage(1,
                        //       duration: const Duration(milliseconds: 300),
                        //       curve: Curves.ease);
                        // }
                        scrollNotifier.pageController.animateToPage(1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease);
                      }),

                  if (controlNotifier.mediaPath.isNotEmpty)
                    ToolButton(
                        child: const Icon(
                          Icons.opacity_outlined,
                          color: Color.fromRGBO(93, 86, 250, 1),
                          size: 30,
                        ),
                        backGroundColor: Colors.white,
                        onTap: () {
                          controlNotifier.isOpacityChanging =
                              !controlNotifier.isOpacityChanging;
                        }),
                  // ToolButton(
                  //     child: const ImageIcon(
                  //       AssetImage('assets/icons/draw.png',
                  //           package: 'stories_editor'),
                  //       color: Colors.white,
                  //       size: 20,
                  //     ),
                  //     backGroundColor: Colors.black12,
                  //     onTap: () {
                  //       controlNotifier.isPainting = true;
                  //       controlNotifier.isOpacityChanging = false;
                  //       //createLinePainting(context: context);
                  //     }),
                  // ToolButton(
                  //   child: ImageIcon(
                  //     const AssetImage('assets/icons/photo_filter.png',
                  //         package: 'stories_editor'),
                  //     color: controlNotifier.isPhotoFilter ? Colors.black : Colors.white,
                  //     size: 20,
                  //   ),
                  //   backGroundColor:  controlNotifier.isPhotoFilter ? Colors.white70 : Colors.black12,
                  //   onTap: () => controlNotifier.isPhotoFilter =
                  //   !controlNotifier.isPhotoFilter,
                  // ),
                  // ToolButton(
                  //     child: const ImageIcon(
                  //       AssetImage('assets/icons/text.png',
                  //           package: 'stories_editor'),
                  //       color: Colors.white,
                  //       size: 20,
                  //     ),
                  //     backGroundColor: Colors.black12,
                  //     onTap: () {
                  //       controlNotifier.isTextEditing =
                  //           !controlNotifier.isTextEditing;
                  //       controlNotifier.isOpacityChanging = false;
                  //     }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// gradient color selector
  // Widget _selectColor({onTap, controlProvider}) {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 5, right: 5, top: 8),
  //     child: AnimatedOnTapButton(
  //       onTap: onTap,
  //       child: Container(
  //         padding: const EdgeInsets.all(2),
  //         decoration: const BoxDecoration(
  //           color: Colors.white,
  //           shape: BoxShape.circle,
  //         ),
  //         child: Container(
  //           width: 30,
  //           height: 30,
  //           decoration: BoxDecoration(
  //             gradient: LinearGradient(
  //                 begin: Alignment.topLeft,
  //                 end: Alignment.bottomRight,
  //                 colors: controlProvider
  //                     .gradientColors![controlProvider.gradientIndex]),
  //             shape: BoxShape.circle,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
