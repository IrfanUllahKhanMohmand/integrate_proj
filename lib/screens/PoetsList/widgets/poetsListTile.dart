import 'package:flutter/material.dart';

class PoetsListTile extends StatelessWidget {
  PoetsListTile(
      {Key? key,
      required this.realName,
      required this.imageUrl,
      required this.noOfGhazals,
      required this.noOfNazams,
      required this.noOfSher})
      : super(key: key);
  final String realName;
  final String imageUrl;
  final int noOfGhazals;
  final int noOfNazams;
  final int noOfSher;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.favorite_border_outlined),
              SizedBox(width: 10),
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: const Color(0xff7c94b6),
                  image: DecorationImage(
                    // image: AssetImage('assets/ahmad-faraz.png'),
                    image: NetworkImage(imageUrl),
                    // image: NetworkImage(
                    //     'https://rekhta.pc.cdn.bitgravity.com/Images/Shayar/ahmad-faraz.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                ),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    realName,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Text(
                      '.$noOfGhazals GHAZAL   .$noOfNazams NAZAM    .$noOfSher SHER',
                      style: TextStyle(fontSize: 10))
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            width: 320,
            child: Divider(
              color: Colors.white,
              thickness: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
