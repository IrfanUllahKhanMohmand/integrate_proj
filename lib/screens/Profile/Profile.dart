import 'package:flutter/material.dart';
import 'package:integration_test/screens/Profile/widgets/profileTobBar.dart';
import 'package:integration_test/screens/Profile/widgets/tabBarTabs.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Text(
              'rekhta',
              style: TextStyle(),
            ),
            Row(
              children: [
                Icon(Icons.search),
                SizedBox(width: 15),
                Icon(Icons.more_vert)
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const ProfileTobBar(
            imageUrl:
                "https://rekhta.pc.cdn.bitgravity.com/Images/Shayar/ahmad-faraz.png",
            fullName: "AHMAD FARAZ",
            yearOfBirth: "1931",
            yearOfDeath: "2008",
            birthPlace: "Peshawar",
          ),
          TabBarTabs(),
        ],
      ),
    );
  }
}
