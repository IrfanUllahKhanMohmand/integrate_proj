import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:integration_test/Providers/admob_provider.dart';
import 'package:integration_test/Providers/local_provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:open_director/Editor/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Providers/category_likes_provider.dart';
import 'Providers/catghazals_likes_provider.dart';
import 'Providers/catnazams_likes_provider.dart';
import 'Providers/catsher_likes_provider.dart';
import 'Providers/ghazals_likes_provider.dart';
import 'Providers/nazams_likes_provider.dart';
import 'Providers/poets_likes_provider.dart';
import 'Providers/shers_likes_provider.dart';
import 'Providers/user_provider.dart';
import 'utils/on_generate_routes.dart';
import 'utils/pallete.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
      testDeviceIds: ['DEBC7A5DD510858F2423568763E55996']));

  setupLocator();
  initializeFlutterDownloader();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Color.fromRGBO(93, 84, 250, 1)));
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => NazamLikesProvider()),
    ChangeNotifierProvider(create: (context) => GhazalLikesProvider()),
    ChangeNotifierProvider(create: (context) => SherLikesProvider()),
    ChangeNotifierProvider(create: (context) => UserProvider()),
    ChangeNotifierProvider(create: (context) => PoetLikesProvider()),
    ChangeNotifierProvider(create: (context) => CategoryLikesProvider()),
    ChangeNotifierProvider(create: (context) => CatNazamLikesProvider()),
    ChangeNotifierProvider(create: (context) => CatGhazalLikesProvider()),
    ChangeNotifierProvider(create: (context) => CatSherLikesProvider()),
    ChangeNotifierProvider(create: (context) => AdMobServicesProvider()),
    ChangeNotifierProvider(create: (context) => LocaleProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Locale> _fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();

    String languageCode = prefs.getString('languageCode') ?? 'ur';
    // String countryCode = prefs.getString('countryCode') ?? 'PK';

    return Locale(languageCode);
  }

  @override
  void initState() {
    Provider.of<AdMobServicesProvider>(context, listen: false).loadBanner();

    _fetchLocale().then((locale) {
      Provider.of<LocaleProvider>(context, listen: false).setLocale(locale);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(builder: (context, value, child) {
      return MaterialApp(
        title: 'Nawees',
        locale: value.locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          FallbackCupertinoLocalisationsDelegate(),
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('ur'), // Urdu
        ],
        initialRoute: '/',
        onGenerateRoute: Routers.generateRoute,
        // home: const LocalizationTest(),
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
    });
  }
}

/*
  To solve problem of hold press on inputs
 */
class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}

initializeFlutterDownloader() async {
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
}
