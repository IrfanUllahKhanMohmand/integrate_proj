import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_director/Editor/service_locator.dart';
import 'package:open_director/Editor/ui/project_list.dart';

class Editor extends StatefulWidget {
  const Editor({Key key}) : super(key: key);

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    //CustomImageCache(); // Disabled at this time
    //setupDevice(); // Disabled at this time
    // setupAnalyticsAndCrashlytics();
    setupLocator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: const Locale('en', 'US'),
      child: Scaffold(
        body: ProjectList(),
      ),
    );
  }
}

// main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   //CustomImageCache(); // Disabled at this time
//   //setupDevice(); // Disabled at this time
//   // setupAnalyticsAndCrashlytics();
//   setupLocator();

// runApp(MultiProvider(
//   providers: [
//     ChangeNotifierProvider(create: (_) => VoumeTracker()),
//   ],
//   child: MyApp(),
// ));
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Open Director',
// theme: ThemeData(
//   primarySwatch: Colors.blue,
//   accentColor: Colors.blue,
//   brightness: Brightness.dark,
//   textTheme: TextTheme(
//     button: TextStyle(color: Colors.white),
//   ),
// ),
//       home: MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (_) => VoumeTracker()),
//         ],
//         child: Scaffold(
//           body: ProjectList(),
//         ),
//       ),
//     );
//   }
// }

setupDevice() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  // Status bar disabled
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

class CustomImageCache extends WidgetsFlutterBinding {
  @override
  ImageCache createImageCache() {
    ImageCache imageCache = super.createImageCache();
    imageCache.maximumSize = 5;
    return imageCache;
  }
}

// class VoumeTracker with ChangeNotifier {
//   double _audioVolume = 0.0;
//   double _videoVolume = 0.0;

//   double get audioVolume => _audioVolume;
//   double get videoVolume => _videoVolume;

//   void setAudioVolume(double vol) {
//     _audioVolume = vol;
//     notifyListeners();
//   }

//   void setVideoVolume(double vol) {
//     _videoVolume = vol;
//     notifyListeners();
//   }
// }
