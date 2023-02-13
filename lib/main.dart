import 'package:flutter/material.dart';
import 'package:integration_test/utils/OnGenerateRoutes.dart';
import 'package:integration_test/utils/pallete.dart';
import 'package:open_director/Editor/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/storiesEditor',
      onGenerateRoute: Routers.generateRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Palette.kToDark,
        colorScheme: ColorScheme.fromSwatch().copyWith(),
        brightness: Brightness.light,
        textTheme: const TextTheme(
          button: TextStyle(color: Colors.white),
        ),
      ),
      // home: const Example(),
    );
  }
}
