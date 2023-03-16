import 'package:flutter/material.dart';
import 'package:integration_test/model/category.dart';
import 'package:integration_test/model/ghazal.dart';
import 'package:integration_test/model/nazam.dart';
import 'package:integration_test/model/poet.dart';
import 'package:integration_test/screens/Category/categor_profile.dart';
import 'package:integration_test/screens/Category/widgets/cat_ghazal_preview.dart';
import 'package:integration_test/screens/Category/widgets/cat_nazam_preview.dart';
import 'package:integration_test/screens/PoetsList/poets_list.dart';
import 'package:integration_test/screens/Profile/profile.dart';
import 'package:integration_test/screens/Profile/widgets/ghazal_preview.dart';
import 'package:integration_test/screens/Profile/widgets/nazam_preview.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:open_director/Editor/ui/project_edit.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:open_director/Editor/ui/project_list.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stories_editor/stories_editor.dart';
import 'constants.dart';

class PoetScreenArguments {
  final int id;

  PoetScreenArguments({required this.id});
}

class NazamPreviewArguments {
  final Nazam nazam;
  final Poet poet;

  NazamPreviewArguments({required this.nazam, required this.poet});
}

class GhazalPreviewArguments {
  final Ghazal ghazal;
  final Poet poet;

  GhazalPreviewArguments({required this.ghazal, required this.poet});
}

class CategoryProfilArguments {
  final int id;

  CategoryProfilArguments({required this.id});
}

class CategoryGhazalPreviewArguments {
  final Ghazal ghazal;
  final Category cat;

  CategoryGhazalPreviewArguments({required this.ghazal, required this.cat});
}

class CategoryNazamPreviewArguments {
  final Category cat;
  final Nazam nazam;

  CategoryNazamPreviewArguments({required this.nazam, required this.cat});
}

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case poetsList:
        return MaterialPageRoute(builder: (_) => const PoetsList());
      case projectList:
        return MaterialPageRoute(builder: (_) => ProjectList());
      case authorProfile:
        {
          final args = settings.arguments as PoetScreenArguments;
          return MaterialPageRoute(builder: (_) => Profile(id: args.id));
        }

      case nazamPreview:
        {
          final args = settings.arguments as NazamPreviewArguments;
          return MaterialPageRoute(
              builder: (_) => NazamPreview(nazam: args.nazam, poet: args.poet));
        }

      case ghazalPreview:
        {
          final args = settings.arguments as GhazalPreviewArguments;
          return MaterialPageRoute(
              builder: (_) =>
                  GhazalPreview(ghazal: args.ghazal, poet: args.poet));
        }
      case categoryProfile:
        {
          final args = settings.arguments as CategoryProfilArguments;
          return MaterialPageRoute(
              builder: (_) => CategoryProfile(id: args.id));
        }

      case categoryNazamPreview:
        {
          final args = settings.arguments as CategoryNazamPreviewArguments;
          return MaterialPageRoute(
              builder: (_) =>
                  CategoryNazamPreview(nazam: args.nazam, cat: args.cat));
        }

      case categoryGhazalPreview:
        {
          final args = settings.arguments as CategoryGhazalPreviewArguments;
          return MaterialPageRoute(
              builder: (_) =>
                  CategoryGhazalPreview(ghazal: args.ghazal, cat: args.cat));
        }
      case projectEdit:
        return MaterialPageRoute(builder: (_) => ProjectEdit(null));
      case storiesEditor:
        {
          return MaterialPageRoute(
              builder: (_) => StoriesEditor(
                    editorBackgroundColor:
                        const Color.fromRGBO(243, 243, 243, 1),
                    giphyKey: 'C4dMA7Q19nqEGdpfj82T8ssbOeZIylD4',
                    galleryThumbnailQuality: 300,
                    middleBottomWidget: Container(),
                    onDone: (uri) {
                      debugPrint(uri);
                      // ignore: deprecated_member_use
                      Share.shareFiles([uri]);
                    },
                  ));
        }
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
