import 'package:flutter/material.dart';
import 'package:integration_test/model/category.dart';

class CategoryProfilesTabView extends StatefulWidget {
  const CategoryProfilesTabView({super.key, required this.category});
  final Category category;

  @override
  State<CategoryProfilesTabView> createState() =>
      _CategoryProfilesTabViewState();
}

class _CategoryProfilesTabViewState extends State<CategoryProfilesTabView> {
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
                  Text('Name:',
                      style: TextStyle(
                          fontSize: 14, color: Colors.black.withOpacity(0.5))),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.category.nameEng,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ]),
            const SizedBox(height: 20),
            Text(
              widget.category.descriptionEng,
              style: const TextStyle(fontSize: 14, color: Colors.black),
              textAlign: TextAlign.justify,
            )
          ],
        ),
      ),
    );
  }
}
