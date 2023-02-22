import 'package:flutter/material.dart';
import 'package:integration_test/screens/Profile/widgets/profileTobBar.dart';
import 'package:integration_test/screens/Profile/widgets/tabBarTabs.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              ProfileTobBar(
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
        ),
      ),
    );
  }
}
