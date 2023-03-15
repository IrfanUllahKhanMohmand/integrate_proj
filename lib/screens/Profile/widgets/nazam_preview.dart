import 'package:flutter/material.dart';
import 'package:integration_test/model/nazam.dart';
import 'package:integration_test/model/poet.dart';

class NazamPreview extends StatelessWidget {
  const NazamPreview({super.key, required this.nazam, required this.poet});
  final Nazam nazam;
  final Poet poet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Icon(
                        Icons.arrow_back_ios,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      nazam.title,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(poet.name.toUpperCase(),
                        style: const TextStyle(
                            color: Color.fromRGBO(93, 86, 250, 1),
                            fontSize: 12,
                            fontWeight: FontWeight.w500)),
                    const Divider(
                      color: Colors.black,
                      thickness: 0.2,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 30),
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        gradient: const LinearGradient(colors: [
                          Color.fromRGBO(37, 28, 216, 1),
                          Color.fromRGBO(121, 115, 248, 1)
                        ]),
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.video_camera_back_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Make Video of this Nazam',
                            style: TextStyle(color: Colors.white, fontSize: 8),
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: const [
                      Icon(Icons.favorite_border_outlined, size: 15),
                      SizedBox(width: 10),
                      Icon(Icons.share, size: 15),
                      SizedBox(width: 10),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    nazam.content,
                    style: const TextStyle(color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
