import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_utils/keyboard_aware/keyboard_aware.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/domain/models/editable_items.dart';
import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:stories_editor/src/presentation/text_editor_view/widgets/animation_selector.dart';
import 'package:stories_editor/src/presentation/text_editor_view/widgets/font_selector.dart';
import 'package:stories_editor/src/presentation/utils/constants/app_enums.dart';
import 'package:stories_editor/src/presentation/widgets/color_selector.dart';
import 'package:stories_editor/src/presentation/widgets/size_slider_selector.dart';

class TextEditor extends StatefulWidget {
  final BuildContext context;
  const TextEditor({Key? key, required this.context}) : super(key: key);

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  final FocusNode _textFieldNode = FocusNode();
  List<String> splitList = [];
  String sequenceList = '';
  String lastSequenceList = '';

  String? __text;
  List<String>? _textList;
  int? _textColor;
  double? _textSize;
  int? _fontFamilyIndex;
  TextAlign? _textAlign;
  Color? _backGroundColor;

  @override
  void initState() {
    final _editorNotifier =
        Provider.of<TextEditingNotifier>(widget.context, listen: false);

    __text = _editorNotifier.textController.text;
    _textList = _editorNotifier.textList;
    _textColor = _editorNotifier.textColor;
    _fontFamilyIndex = _editorNotifier.fontFamilyIndex;
    _textAlign = _editorNotifier.textAlign;
    _backGroundColor = _editorNotifier.backGroundColor;
    _textSize = _editorNotifier.textSize;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final _editorNotifier =
          Provider.of<TextEditingNotifier>(widget.context, listen: false);
      _editorNotifier
        ..textController.text = _editorNotifier.text
        ..fontFamilyController = PageController(viewportFraction: .125);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ScreenUtil screenUtil = ScreenUtil();

    return Material(
        color: Colors.transparent,
        child: Consumer2<ControlNotifier, TextEditingNotifier>(
          builder: (_, controlNotifier, editorNotifier, __) {
            return KeyboardAware(builder: (context, keyboardConfig) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: Container(
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.5)),
                    height: screenUtil.screenHeight,
                    width: screenUtil.screenWidth,
                    child: Stack(
                      children: [
                        /// text field
                        Positioned(
                          bottom: keyboardConfig.keyboardHeight == 0
                              ? screenUtil.screenHeight / 2
                              : keyboardConfig.keyboardHeight + 80,
                          left: 0,
                          right: 0,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: screenUtil.screenWidth - 100,
                            ),
                            child: IntrinsicWidth(

                                /// textField Box decoration
                                child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Padding(
                                //   padding: const EdgeInsets.only(right: 2),
                                //   child: _text(
                                //     editorNotifier: editorNotifier,
                                //     textNode: _textFieldNode,
                                //     controlNotifier: controlNotifier,
                                //     paintingStyle: PaintingStyle.fill,
                                //   ),
                                // ),
                                _textField(
                                  editorNotifier: editorNotifier,
                                  textNode: _textFieldNode,
                                  controlNotifier: controlNotifier,
                                  paintingStyle: PaintingStyle.stroke,
                                )
                              ],
                            )),
                          ),
                        ),

                        /// text size
                        keyboardConfig.keyboardHeight != 0
                            ? Positioned(
                                left: 5,
                                bottom: keyboardConfig.keyboardHeight + 30,
                                child: const SizeSliderWidget(),
                              )
                            : const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: SizeSliderWidget(),
                                ),
                              ),

                        /// top tools
                        // SafeArea(
                        //   child: Align(
                        //       alignment: Alignment.topCenter,
                        //       child: TopTextTools(
                        //         onDone: () => _onTap(
                        //             context, controlNotifier, editorNotifier),
                        //       )),
                        // ),

                        /// font family selector (bottom)
                        Positioned(
                          bottom: screenUtil.screenHeight * 0.02,
                          child: Visibility(
                            visible: editorNotifier.isFontFamily &&
                                !editorNotifier.isTextAnimation,
                            child: const Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: FontSelector(),
                              ),
                            ),
                          ),
                        ),

                        /// font color selector (bottom)
                        Positioned(
                          bottom: screenUtil.screenHeight * 0.02,
                          child: Visibility(
                              visible: !editorNotifier.isFontFamily &&
                                  !editorNotifier.isTextAnimation,
                              child: const Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child: ColorSelector(),
                                ),
                              )),
                        ),

                        /// font animation selector (bottom
                        Positioned(
                          bottom: screenUtil.screenHeight * 0.21,
                          child: Visibility(
                              visible: editorNotifier.isTextAnimation,
                              child: const Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child: AnimationSelector(),
                                ),
                              )),
                        ),
                        Positioned(
                          bottom: keyboardConfig.keyboardHeight != 0
                              ? keyboardConfig.keyboardHeight
                              : 100,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 50,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        _onClose(context, controlNotifier,
                                            editorNotifier);
                                      },
                                      child: const Icon(Icons.close)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                          onTap: () async {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            await Future.delayed(
                                                const Duration(milliseconds: 1),
                                                () {
                                              _textFieldNode.requestFocus();
                                            });

                                            // _textFieldNode.unfocus();
                                          },
                                          child: const Icon(
                                              Icons.keyboard_alt_outlined)),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                          onTap: () {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            editorNotifier.isFontFamily = false;
                                            editorNotifier.isTextAnimation =
                                                false;
                                          },
                                          child: const Icon(
                                              Icons.color_lens_rounded)),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          editorNotifier.isFontFamily = true;
                                        },
                                        child: const Icon(
                                            Icons.font_download_outlined),
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                          onTap: () {
                                            editorNotifier.onAlignmentChange();
                                          },
                                          child: Icon(
                                            editorNotifier.textAlign ==
                                                    TextAlign.center
                                                ? Icons.format_align_center
                                                : editorNotifier.textAlign ==
                                                        TextAlign.right
                                                    ? Icons.format_align_right
                                                    : Icons.format_align_left,
                                          )),
                                    ],
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        _onTap(context, controlNotifier,
                                            editorNotifier);
                                      },
                                      child: const Icon(Icons.check))
                                ],
                              ),
                            ),
                            decoration:
                                const BoxDecoration(color: Colors.white),
                          ),
                        ),
                      ],
                    )),
              );
            });
          },
        ));
  }

  void _onTap(context, ControlNotifier controlNotifier,
      TextEditingNotifier editorNotifier) {
    final _editableItemNotifier =
        Provider.of<DraggableWidgetNotifier>(context, listen: false);

    /// create text list
    if (editorNotifier.text.trim().isNotEmpty) {
      splitList = editorNotifier.text.split(' ');
      for (int i = 0; i < splitList.length; i++) {
        if (i == 0) {
          editorNotifier.textList.add(splitList[0]);
          sequenceList = splitList[0];
        } else {
          lastSequenceList = sequenceList;
          editorNotifier.textList.add(sequenceList + ' ' + splitList[i]);
          sequenceList = lastSequenceList + ' ' + splitList[i];
        }
      }

      /// create Text Item
      _editableItemNotifier.draggableWidget.add(EditableItem()
        ..type = ItemType.text
        ..text = editorNotifier.text.trim()
        ..backGroundColor = editorNotifier.backGroundColor
        ..textColor = controlNotifier.colorList![editorNotifier.textColor]
        ..fontFamily = editorNotifier.fontFamilyIndex
        ..fontSize = editorNotifier.textSize
        ..fontAnimationIndex = editorNotifier.fontAnimationIndex
        ..textAlign = editorNotifier.textAlign
        ..textList = editorNotifier.textList
        ..animationType =
            editorNotifier.animationList[editorNotifier.fontAnimationIndex]
        ..position = const Offset(0.0, 0.0));
      editorNotifier.setDefaults();
      controlNotifier.isTextEditing = !controlNotifier.isTextEditing;
    } else {
      editorNotifier.setDefaults();

      controlNotifier.isTextEditing = !controlNotifier.isTextEditing;
    }
  }

  void _onClose(context, ControlNotifier controlNotifier,
      TextEditingNotifier editorNotifier) {
    // editorNotifier.setDefaults();
    final _editableItemNotifier =
        Provider.of<DraggableWidgetNotifier>(context, listen: false);

    /// create text list
    if (__text != null && __text != '') {
      splitList = __text!.split(' ');
      for (int i = 0; i < splitList.length; i++) {
        if (i == 0) {
          _textList!.add(splitList[0]);
          sequenceList = splitList[0];
        } else {
          lastSequenceList = sequenceList;
          _textList!.add(sequenceList + ' ' + splitList[i]);
          sequenceList = lastSequenceList + ' ' + splitList[i];
        }
      }

      /// create Text Item
      _editableItemNotifier.draggableWidget.add(EditableItem()
        ..type = ItemType.text
        ..text = __text!.trim()
        ..backGroundColor = _backGroundColor!
        ..textColor = controlNotifier.colorList![_textColor!]
        ..fontFamily = _fontFamilyIndex!
        ..fontSize = _textSize!
        ..fontAnimationIndex = editorNotifier.fontAnimationIndex
        ..textAlign = _textAlign!
        ..textList = _textList!
        ..animationType =
            editorNotifier.animationList[editorNotifier.fontAnimationIndex]
        ..position = const Offset(0.0, 0.0));
      editorNotifier.setDefaults();
      controlNotifier.isTextEditing = !controlNotifier.isTextEditing;
    } else {
      editorNotifier.setDefaults();

      controlNotifier.isTextEditing = !controlNotifier.isTextEditing;
    }
  }

  willPopCallBack() {
    final _editableItemNotifier =
        Provider.of<DraggableWidgetNotifier>(context, listen: false);
    final controlNotifier =
        Provider.of<ControlNotifier>(context, listen: false);
    final editorNotifier =
        Provider.of<TextEditingNotifier>(context, listen: false);

    /// create text list
    if (__text != null && __text != '') {
      splitList = __text!.split(' ');
      for (int i = 0; i < splitList.length; i++) {
        if (i == 0) {
          _textList!.add(splitList[0]);
          sequenceList = splitList[0];
        } else {
          lastSequenceList = sequenceList;
          _textList!.add(sequenceList + ' ' + splitList[i]);
          sequenceList = lastSequenceList + ' ' + splitList[i];
        }
      }

      /// create Text Item
      _editableItemNotifier.draggableWidget.add(EditableItem()
        ..type = ItemType.text
        ..text = __text!.trim()
        ..backGroundColor = _backGroundColor!
        ..textColor = controlNotifier.colorList![_textColor!]
        ..fontFamily = _fontFamilyIndex!
        ..fontSize = _textSize!
        ..fontAnimationIndex = editorNotifier.fontAnimationIndex
        ..textAlign = _textAlign!
        ..textList = _textList!
        ..animationType =
            editorNotifier.animationList[editorNotifier.fontAnimationIndex]
        ..position = const Offset(0.0, 0.0));
      editorNotifier.setDefaults();
      controlNotifier.isTextEditing = !controlNotifier.isTextEditing;
    } else {
      editorNotifier.setDefaults();

      controlNotifier.isTextEditing = !controlNotifier.isTextEditing;
    }
  }
}

Widget _text({
  required TextEditingNotifier editorNotifier,
  required FocusNode textNode,
  required ControlNotifier controlNotifier,
  required PaintingStyle paintingStyle,
}) {
  return Text(
    editorNotifier.textController.text,
    textAlign: editorNotifier.textAlign,
    style: TextStyle(
        fontFamily: controlNotifier.fontList![editorNotifier.fontFamilyIndex],
        package: controlNotifier.isCustomFontList ? null : 'stories_editor',
        shadows: <Shadow>[
          Shadow(
              offset: const Offset(1.0, 1.0),
              blurRadius: 3.0,
              color: controlNotifier.colorList![editorNotifier.textColor] ==
                      Colors.black
                  ? Colors.white54
                  : Colors.black)
        ]).copyWith(
        color: controlNotifier.colorList![editorNotifier.textColor],
        fontSize: editorNotifier.textSize,
        background: Paint()
          ..strokeWidth = 20.0
          ..color = editorNotifier.backGroundColor
          ..style = paintingStyle
          ..strokeJoin = StrokeJoin.round
          ..filterQuality = FilterQuality.high
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 1)),
  );
}

Widget _textField({
  required TextEditingNotifier editorNotifier,
  required FocusNode textNode,
  required ControlNotifier controlNotifier,
  required PaintingStyle paintingStyle,
}) {
  return TextField(
    focusNode: textNode,
    autofocus: true,
    textInputAction: TextInputAction.newline,
    controller: editorNotifier.textController,
    textAlign: editorNotifier.textAlign,
    style: TextStyle(
            fontFamily:
                controlNotifier.fontList![editorNotifier.fontFamilyIndex],
            package: controlNotifier.isCustomFontList ? null : 'stories_editor',
            shadows: <Shadow>[
              Shadow(
                  offset: const Offset(1.0, 1.0),
                  blurRadius: 3.0,
                  color: controlNotifier.colorList![editorNotifier.textColor] ==
                          Colors.black
                      ? Colors.white54
                      : Colors.black)
            ],
            backgroundColor: Colors.redAccent)
        .copyWith(
      color: controlNotifier.colorList![editorNotifier.textColor],
      fontSize: editorNotifier.textSize,
      background: Paint()
        ..strokeWidth = 20.0
        ..color = editorNotifier.backGroundColor
        ..style = paintingStyle
        ..strokeJoin = StrokeJoin.round
        ..filterQuality = FilterQuality.high
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 1),
      shadows: <Shadow>[
        Shadow(
            offset: const Offset(1.0, 1.0),
            blurRadius: 3.0,
            color: controlNotifier.colorList![editorNotifier.textColor] ==
                    Colors.black
                ? Colors.white54
                : Colors.black)
      ],
    ),
    cursorColor: controlNotifier.colorList![editorNotifier.textColor],
    minLines: 1,
    keyboardType: TextInputType.multiline,
    maxLines: null,
    decoration: null,
    onChanged: (value) {
      editorNotifier.text = value;
    },
  );
}
