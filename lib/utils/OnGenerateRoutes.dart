import 'package:flutter/material.dart';
import 'package:integration_test/screens/PoetsList/PoetsList.dart';
import 'package:integration_test/screens/Profile/Profile.dart';
import 'package:integration_test/screens/Profile/widgets/ghazalPreview.dart';
import 'package:integration_test/screens/Profile/widgets/nazamPreview.dart';
import 'package:open_director/Editor/ui/project_list.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stories_editor/stories_editor.dart';

import 'constants.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case poetsList:
        return MaterialPageRoute(builder: (_) => const PoetsList());
      case projectList:
        return MaterialPageRoute(builder: (_) => ProjectList());
      case authorProfile:
        return MaterialPageRoute(builder: (_) => const Profile());
      case nazamPreview:
        return MaterialPageRoute(builder: (_) => const NazamPreview());
      case ghazalPreview:
        return MaterialPageRoute(builder: (_) => const GhazalPreview());
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
