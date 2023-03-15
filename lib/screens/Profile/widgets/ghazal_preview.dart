import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:integration_test/utils/constants.dart';

import 'package:share_plus/share_plus.dart';

class GhazalPreview extends StatelessWidget {
  const GhazalPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            const Text(
              'rekhta',
              style: TextStyle(),
            ),
            Row(
              children: const [SizedBox(width: 15), Icon(Icons.more_vert)],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'ranjish hi sahi dil hi dukhane ke liye aa',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('AHMAD FARAZ', style: TextStyle(color: Colors.white)),
                  Divider(
                    color: Colors.white,
                    thickness: 0.2,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            const Text(
              'ranjish hī sahī dil hī dukhāne ke liye aa\naa phir se mujhe chhoḌ ke jaane ke liye aa\n\nkuchh to mire pindār-e-mohabbat kā bharam rakh\ntū bhī to kabhī mujh ko manāne ke liye aa\n\npahle se marāsim na sahī phir bhī kabhī to\nrasm-o-rah-e-duniyā hī nibhāne ke liye aa\n\nkis kis ko batā.eñge judā.ī kā sabab ham\ntū mujh se ḳhafā hai to zamāne ke liye aa\n\nik umr se huuñ lazzat-e-girya se bhī mahrūm\nai rāhat-e-jāñ mujh ko rulāne ke liye aa\n\nab tak dil-e-ḳhush-fahm ko tujh se haiñ ummīdeñ\nye āḳhirī sham.eñ bhī bujhāne ke liye aa ',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.justify,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      // final box = context.findRenderObject() as RenderBox;
                      // await Share.share(
                      //     'ranjish hi sahi dil hi dhukhane ke liye aa\naa phir se mujhe chhor ke jaane ke liye aa',
                      //     sharePositionOrigin:
                      //         box.localToGlobal(Offset.zero) & box.size);
                      await Share.share(
                          'ranjish hi sahi dil hi dhukhane ke liye aa\naa phir se mujhe chhor ke jaane ke liye aa');
                    },
                    child: const Icon(
                      Icons.share,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () async {
                      await Clipboard.setData(const ClipboardData(
                          text:
                              'ranjish hi sahi dil hi dhukhane ke liye aa\naa phir se mujhe chhor ke jaane ke liye aa'));
                      // copied successfully
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'copied successfully',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        duration: const Duration(seconds: 1),
                        backgroundColor: Colors.transparent,
                      ));
                      Navigator.pushNamed(context, projectList);
                    },
                    child: const Icon(
                      Icons.copy,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
