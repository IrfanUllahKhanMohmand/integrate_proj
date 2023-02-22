import 'package:flutter/material.dart';
import 'package:integration_test/screens/Profile/widgets/nazamTile.dart';
import 'package:integration_test/utils/constants.dart';

class NazamsTabView extends StatelessWidget {
  const NazamsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("NAZAM",
                  style: TextStyle(color: Color.fromRGBO(93, 86, 250, 1))),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .52,
          child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      nazamPreview,
                    );
                  },
                  child: Column(
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: NazamTile(),
                      )
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }
}
