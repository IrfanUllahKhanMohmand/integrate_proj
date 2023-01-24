import 'package:flutter/material.dart';
import 'package:integration_test/utils/constants.dart';

class GhazalsTabView extends StatelessWidget {
  const GhazalsTabView({key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Text("GHAZAL", style: TextStyle(color: Colors.white)),
                  SizedBox(width: 5),
                  Text("137", style: TextStyle(color: Colors.white)),
                ],
              ),
              const Icon(
                Icons.tune,
                color: Colors.white,
              )
            ],
          ),
        ),
        SizedBox(
          height: 360,
          child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ghazalPreview,
                    );
                  },
                  child: Column(
                    children: const [
                      ListTile(
                        leading:
                            Icon(Icons.favorite_outline, color: Colors.white),
                        title: Text(
                          'suna hai log use aankh bhar ke dekhte hay....................',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Divider(
                          color: Colors.white,
                          thickness: 0.2,
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }
}
