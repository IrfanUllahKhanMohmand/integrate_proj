import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/domain/models/editable_items.dart';
import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/scroll_notifier.dart';
import 'package:stories_editor/src/presentation/utils/constants/app_enums.dart';
import 'package:transparent_image/transparent_image.dart';

class PickOnlineImages extends StatefulWidget {
  const PickOnlineImages({super.key});

  @override
  State<PickOnlineImages> createState() => _PickOnlineImagesState();
}

class _PickOnlineImagesState extends State<PickOnlineImages> {
  dynamic urlData;
  dynamic _scrollController;
  bool isLoading = false;
  var textController = TextEditingController();
  List<String> imageListNew = [];
  getApiData(String search) async {
    setState(() {
      isLoading = true;
    });
    imageListNew = [];
    var url = Uri.parse(
        'https://api.unsplash.com/search/photos/?page=1&per_page=30&query=${search.trim()}&client_id=XgscPMNOWiabPbYstw2sBRekrTsurK84QLyCA9la7Tk');
    final res = await http.get(url);
    setState(() {
      urlData = jsonDecode(res.body);
      (urlData['results'] as List).forEach(((element) {
        imageListNew.add(element['urls']['regular']);
      }));
      // log(urlData['results'].toString());
    });
    setState(() {
      isLoading = false;
    });
  }

  List<String> imageList = [
    'https://cdn.pixabay.com/photo/2019/03/15/09/49/girl-4056684_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/12/15/16/25/clock-5834193__340.jpg',
    'https://cdn.pixabay.com/photo/2020/09/18/19/31/laptop-5582775_960_720.jpg',
    'https://media.istockphoto.com/photos/woman-kayaking-in-fjord-in-norway-picture-id1059380230?b=1&k=6&m=1059380230&s=170667a&w=0&h=kA_A_XrhZJjw2bo5jIJ7089-VktFK0h0I4OWDqaac0c=',
    'https://cdn.pixabay.com/photo/2019/11/05/00/53/cellular-4602489_960_720.jpg',
    'https://cdn.pixabay.com/photo/2017/02/12/10/29/christmas-2059698_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/01/29/17/09/snowboard-4803050_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/02/06/20/01/university-library-4825366_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/11/22/17/28/cat-5767334_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/12/13/16/22/snow-5828736_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/12/09/09/27/women-5816861_960_720.jpg',
  ];

  download(String url) async {
    var file = await DefaultCacheManager().getSingleFile(url);
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
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
            toolbarTitle: Localizations.localeOf(context).languageCode == 'ur'
                ? 'تصویر کو تراشیں'
                : 'Crop Image',
            toolbarColor: Colors.grey,
            statusBarColor: const Color.fromRGBO(93, 86, 250, 1),
            backgroundColor: const Color.fromRGBO(245, 245, 247, 1),
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

    Provider.of<ControlNotifier>(context, listen: false).mediaPath =
        croppedFile!.path.toString();
    // controlNotifier.mediaPath = path.first.path!.toString();
    if (Provider.of<ControlNotifier>(context, listen: false)
        .mediaPath
        .isNotEmpty) {
      Provider.of<DraggableWidgetNotifier>(context, listen: false)
          .draggableWidget
          .insert(
              0,
              EditableItem()
                ..type = ItemType.image
                ..position = const Offset(0.0, 0));
    }
    Provider.of<ScrollNotifier>(context, listen: false)
        .pageController
        .animateToPage(0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  @override
  void initState() {
    super.initState();
    getApiData('Cars');
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        if (_scrollController.position.minScrollExtent ==
            _scrollController.offset) {
          Provider.of<ScrollNotifier>(context, listen: false)
              .pageController
              .animateToPage(0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white24,
          body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 10),
                SizedBox(
                  height: 45,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        getButtonUI(CategoryType.cars,
                            categoryType == CategoryType.cars),
                        const SizedBox(
                          width: 8,
                        ),
                        getButtonUI(CategoryType.books,
                            categoryType == CategoryType.books),
                        const SizedBox(
                          width: 8,
                        ),
                        getButtonUI(CategoryType.flags,
                            categoryType == CategoryType.flags),
                        const SizedBox(
                          width: 8,
                        ),
                        getButtonUI(CategoryType.clocks,
                            categoryType == CategoryType.clocks),
                        const SizedBox(
                          width: 8,
                        ),
                        getButtonUI(CategoryType.shoes,
                            categoryType == CategoryType.shoes),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Localizations.override(
                  context: context,
                  locale: const Locale('en', 'US'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: TextField(
                      controller: textController,
                      cursorColor: const Color.fromRGBO(93, 86, 250, 1),
                      decoration: InputDecoration(
                          suffixIcon: InkWell(
                            onTap: () async {
                              categoryType = CategoryType.none;
                              if (textController.text != '') {
                                await getApiData(textController.text);
                              }

                              textController.text = '';
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(24),
                                    bottomRight: Radius.circular(24)),
                                color: Color.fromRGBO(93, 86, 250, 1),
                              ),
                              child: const Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color.fromRGBO(93, 86, 250, 1),
                          ),
                          prefixIconColor: const Color.fromRGBO(93, 86, 250, 1),
                          enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(93, 86, 250, 1))),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(93, 86, 250, 1))),
                          border: const OutlineInputBorder(),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8)),
                    ),
                  ),
                ),
                imageListNew.isNotEmpty && !isLoading
                    ? Container(
                        height: 580,
                        margin: const EdgeInsets.all(5),
                        child: MasonryGridView.count(
                          controller: _scrollController,
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          itemCount: imageListNew.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              // onPanUpdate: (details) {
                              //   if (_scrollController.position.maxScrollExtent ==
                              //       _scrollController.offset) {
                              //     Provider.of<ScrollNotifier>(context, listen: false)
                              // .pageController
                              // .animateToPage(0,
                              //     duration: const Duration(milliseconds: 300),
                              //     curve: Curves.easeIn);
                              //   }
                              // },
                              // onVerticalDragEnd: (details) {
                              //   if (Provider.of<ScrollNotifier>(context, listen: false)
                              //           .pageController
                              //           .page ==
                              //       1.0) {
                              //     Provider.of<ScrollNotifier>(context, listen: false)
                              //         .pageController
                              //         .animateToPage(0,
                              //             duration: const Duration(milliseconds: 300),
                              //             curve: Curves.easeIn);
                              //   }
                              //   log(Provider.of<ScrollNotifier>(context, listen: false)
                              //       .pageController
                              //       .page
                              //       .toString());
                              // },
                              onTap: () async {
                                await download(imageListNew[index]);
                                // Provider.of<PaintingNotifier>(context,
                                //         listen: false)
                                //     .fullImageViewUrl = imageListNew[index];
                                // Provider.of<PaintingNotifier>(context,
                                //             listen: false)
                                //         .fullImageViewDownloadLink =
                                //     imageListNew[index];
                                // Provider.of<PaintingNotifier>(context,
                                //         listen: false)
                                //     .fullImageViewIndex = index;

                                // Provider.of<ScrollNotifier>(context,
                                //         listen: false)
                                //     .pageController
                                //     .animateToPage(3,
                                //         duration:
                                //             const Duration(milliseconds: 300),
                                //         curve: Curves.easeIn);
                                // Navigator.push(context,
                                //     MaterialPageRoute(builder: (context) {
                                //   return FullImageView(
                                //     url: urlData[index]['urls']['regular'],
                                //     ind: index,
                                //     downloadLink: urlData[index]['links']['download'],
                                //   );
                                // }));
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: imageListNew[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : isLoading
                        ? SizedBox(
                            height: 400,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                CircularProgressIndicator(),
                              ],
                            ),
                          )
                        : Container(
                            height: 580,
                            margin: const EdgeInsets.all(5),
                            child: MasonryGridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              itemCount: imageList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () async {
                                    await download(imageList[index]);
                                    // Provider.of<PaintingNotifier>(context,
                                    //         listen: false)
                                    //     .fullImageViewUrl = imageList[index];
                                    // Provider.of<PaintingNotifier>(context,
                                    //             listen: false)
                                    //         .fullImageViewDownloadLink =
                                    //     imageList[index];
                                    // Provider.of<PaintingNotifier>(context,
                                    //         listen: false)
                                    //     .fullImageViewIndex = index;

                                    // Provider.of<ScrollNotifier>(context,
                                    //         listen: false)
                                    //     .pageController
                                    //     .animateToPage(2,
                                    //         duration: const Duration(
                                    //             milliseconds: 300),
                                    //         curve: Curves.easeIn);
                                  },
                                  child: Hero(
                                    tag: index,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)),
                                        child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image: imageList[index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ],
            ),
          )),
    );
  }

  CategoryType categoryType = CategoryType.cars;
  Widget getButtonUI(CategoryType categoryTypeData, bool isSelected) {
    String txt = '';
    String srchText = '';
    if (CategoryType.cars == categoryTypeData) {
      txt = 'Cars';
      srchText = 'Cars';
    } else if (CategoryType.books == categoryTypeData) {
      txt = 'Books';
      srchText = 'Books';
    } else if (CategoryType.flags == categoryTypeData) {
      txt = 'Flags';
      srchText = 'Flags';
    } else if (CategoryType.clocks == categoryTypeData) {
      txt = 'Clocks';
      srchText = 'Clocks';
    } else if (CategoryType.shoes == categoryTypeData) {
      txt = 'Shoes';
      srchText = 'Shoes';
    }
    return Container(
      decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromRGBO(93, 86, 250, 1)
              : DesignCourseAppTheme.nearlyWhite,
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          border: Border.all(color: const Color.fromRGBO(93, 86, 250, 1))),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white24,
          borderRadius: const BorderRadius.all(Radius.circular(24.0)),
          onTap: () async {
            setState(() {
              categoryType = categoryTypeData;
            });
            await getApiData(srchText);
          },
          child: Padding(
            padding:
                const EdgeInsets.only(top: 2, bottom: 2, left: 28, right: 28),
            child: Center(
              child: Text(
                txt,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.27,
                  color: isSelected
                      ? DesignCourseAppTheme.nearlyWhite
                      : const Color.fromRGBO(93, 86, 250, 1),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FullImageView extends StatefulWidget {
  final String url;
  final int ind;
  final String downloadLink;
  const FullImageView(
      {super.key,
      required this.url,
      required this.ind,
      required this.downloadLink});

  @override
  State<FullImageView> createState() => _FullImageViewState();
}

class _FullImageViewState extends State<FullImageView> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          download(widget.url);
          log(widget.downloadLink);
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(widget.url), fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

  download(String url) async {
    var file = await DefaultCacheManager().getSingleFile(url);
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
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
            toolbarTitle: Localizations.localeOf(context).languageCode == 'ur'
                ? 'تصویر کو تراشیں'
                : 'Crop Image',
            toolbarColor: Colors.grey,
            backgroundColor: const Color.fromRGBO(245, 245, 247, 1),
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

    Provider.of<ControlNotifier>(context, listen: false).mediaPath =
        croppedFile!.path.toString();
    // controlNotifier.mediaPath = path.first.path!.toString();
    if (Provider.of<ControlNotifier>(context, listen: false)
        .mediaPath
        .isNotEmpty) {
      Provider.of<DraggableWidgetNotifier>(context, listen: false)
          .draggableWidget
          .insert(
              0,
              EditableItem()
                ..type = ItemType.image
                ..position = const Offset(0.0, 0));
    }
    Provider.of<ScrollNotifier>(context, listen: false)
        .pageController
        .animateToPage(0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }
}

// class FullImageView extends StatefulWidget {
//   final String url;
//   final int ind;
//   final String downloadLink;
//   const FullImageView(
//       {super.key,
//       required this.url,
//       required this.ind,
//       required this.downloadLink});

//   @override
//   State<FullImageView> createState() => _FullImageViewState();
// }

// class _FullImageViewState extends State<FullImageView> {
//   late var baseStorage;
//   late var uuid;
//   final ReceivePort _port = ReceivePort();
//   @override
//   void initState() {
//     super.initState();

//     IsolateNameServer.registerPortWithName(
//         _port.sendPort, 'downloader_send_port');
//     _port.listen((dynamic data) async {
//       String id = data[0];
//       DownloadTaskStatus status = data[1];
//       int progress = data[2];

//       if (status == DownloadTaskStatus.complete) {
//         CroppedFile? croppedFile = await ImageCropper().cropImage(
//           sourcePath: "${baseStorage!.path}/$uuid",
//           aspectRatioPresets: Platform.isAndroid
//               ? [
//                   CropAspectRatioPreset.square,
//                   CropAspectRatioPreset.ratio3x2,
//                   CropAspectRatioPreset.original,
//                   CropAspectRatioPreset.ratio4x3,
//                   CropAspectRatioPreset.ratio16x9
//                 ]
//               : [
//                   CropAspectRatioPreset.original,
//                   CropAspectRatioPreset.square,
//                   CropAspectRatioPreset.ratio3x2,
//                   CropAspectRatioPreset.ratio4x3,
//                   CropAspectRatioPreset.ratio5x3,
//                   CropAspectRatioPreset.ratio5x4,
//                   CropAspectRatioPreset.ratio7x5,
//                   CropAspectRatioPreset.ratio16x9
//                 ],
//           uiSettings: [
//             AndroidUiSettings(
//                 toolbarColor: Colors.black,
//                 toolbarWidgetColor: Colors.white,
//                 // initAspectRatio: CropAspectRatioPreset.original,
//                 hideBottomControls: true,
//                 lockAspectRatio: false),
//             IOSUiSettings(
//               title: 'Cropper',
//             ),
//             WebUiSettings(
//               context: context,
//             ),
//           ],
//         );

//         Provider.of<ControlNotifier>(context, listen: false).mediaPath =
//             croppedFile!.path.toString();
//         // controlNotifier.mediaPath = path.first.path!.toString();
//         if (Provider.of<ControlNotifier>(context, listen: false)
//             .mediaPath
//             .isNotEmpty) {
//           Provider.of<DraggableWidgetNotifier>(context, listen: false)
//               .draggableWidget
//               .insert(
//                   0,
//                   EditableItem()
//                     ..type = ItemType.image
//                     ..position = const Offset(0.0, 0));
//         }
//         Provider.of<ScrollNotifier>(context, listen: false)
//             .pageController
//             .animateToPage(0,
//                 duration: const Duration(milliseconds: 300),
//                 curve: Curves.easeIn);
//       }
//       setState(() {});
//     });

//     FlutterDownloader.registerCallback(downloadCallback);
//   }

//   @override
//   void dispose() {
//     IsolateNameServer.removePortNameMapping('downloader_send_port');
//     super.dispose();
//   }

//   @pragma('vm:entry-point')
//   static void downloadCallback(
//       String id, DownloadTaskStatus status, int progress) {
//     final SendPort? send =
//         IsolateNameServer.lookupPortByName('downloader_send_port');
//     send!.send([id, status, progress]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: InkWell(
//         onTap: () {
//           download(widget.url);
//           log(widget.downloadLink);
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//                 image: NetworkImage(widget.url), fit: BoxFit.contain),
//           ),
//         ),
//       ),
//     );
//   }

//   download(String url) async {
//     var status = await Permission.storage.request();
//     if (status.isGranted) {
//       baseStorage = await getExternalStorageDirectory();
//       uuid = const Uuid().v4();
//       await FlutterDownloader.enqueue(
//         fileName: uuid,
//         url: url,
//         headers: {}, // optional: header send with url (auth token etc)
//         savedDir: baseStorage!.path,
//         showNotification:
//             true, // show download progress in status bar (for Android)
//         openFileFromNotification:
//             true, // click on notification to open downloaded file (for Android)
//       );
//     }
//   }
// }

enum CategoryType { cars, books, shoes, flags, clocks, none }

class DesignCourseAppTheme {
  DesignCourseAppTheme._();

  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFFFFFF);
  static const Color nearlyBlue = Color(0xFF00B6F0);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color darkGrey = Color(0xFF313A44);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color spacer = Color(0xFFF2F2F2);

  static const TextTheme textTheme = TextTheme(
    headlineMedium: display1,
    headlineSmall: headline,
    titleLarge: title,
    titleSmall: subtitle,
    bodyLarge: body2,
    bodyMedium: body1,
    bodySmall: caption,
  );

  static const TextStyle display1 = TextStyle(
    // h4 -> display1
    fontFamily: 'WorkSans',
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle(
    // h5 -> headline
    fontFamily: 'WorkSans',
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle(
    // h6 -> title
    fontFamily: 'WorkSans',
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle(
    // subtitle2 -> subtitle
    fontFamily: 'WorkSans',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    // body1 -> body2
    fontFamily: 'WorkSans',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle(
    // body2 -> body1
    fontFamily: 'WorkSans',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    // Caption -> caption
    fontFamily: 'WorkSans',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );
}
