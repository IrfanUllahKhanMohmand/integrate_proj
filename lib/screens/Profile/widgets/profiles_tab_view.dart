import 'package:flutter/material.dart';
import 'package:integration_test/model/poet.dart';

class ProfilesTabView extends StatefulWidget {
  const ProfilesTabView({super.key, required this.poet});
  final Poet poet;

  @override
  State<ProfilesTabView> createState() => _ProfilesTabViewState();
}

class _ProfilesTabViewState extends State<ProfilesTabView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            Row(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pen Name:',
                      style: TextStyle(
                          fontSize: 14, color: Colors.black.withOpacity(0.5))),
                  Text('Real Name:',
                      style: TextStyle(
                          fontSize: 14, color: Colors.black.withOpacity(0.5))),
                  Text('Born:',
                      style: TextStyle(
                          fontSize: 14, color: Colors.black.withOpacity(0.5))),
                  Text('Died:',
                      style: TextStyle(
                          fontSize: 14, color: Colors.black.withOpacity(0.5))),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.poet.name,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  Text(
                    widget.poet.fatherName,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  Text(
                    '${widget.poet.birthDate} | Kohat, Pakistan',
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  Text(
                    '${widget.poet.deathDate} | Kohat, Pakistan',
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ]),
            const SizedBox(height: 20),
            Text(
              widget.poet.description,
              style: const TextStyle(fontSize: 14, color: Colors.black),
              textAlign: TextAlign.justify,
            )
          ],
        ),
      ),
    );
  }
}
