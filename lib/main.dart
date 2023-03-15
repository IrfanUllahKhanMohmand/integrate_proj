import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:integration_test/utils/on_generate_routes.dart';
import 'package:integration_test/utils/pallete.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:open_director/Editor/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  initializeFlutterDownloader();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Color.fromRGBO(93, 84, 250, 1)));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nawees',
      initialRoute: '/',
      onGenerateRoute: Routers.generateRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Palette.kToDark,
        colorScheme: ColorScheme.fromSwatch().copyWith(),
        brightness: Brightness.light,
        textTheme: const TextTheme(
          labelLarge: TextStyle(color: Colors.white),
        ),
      ),
      // home: const Example(),
    );
  }
}

initializeFlutterDownloader() async {
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
}
