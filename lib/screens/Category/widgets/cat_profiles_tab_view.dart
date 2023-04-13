import 'package:flutter/material.dart';
import 'package:integration_test/Providers/local_provider.dart';
import 'package:integration_test/model/category.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        child: Consumer<LocaleProvider>(builder: (context, value, child) {
          return Column(
            children: [
              Row(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${AppLocalizations.of(context)!.poet_name}:',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.5))),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value.locale!.languageCode == 'ur'
                          ? widget.category.nameUrd
                          : widget.category.nameEng,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ]),
              const SizedBox(height: 20),
              Text(
                value.locale!.languageCode == 'ur'
                    ? widget.category.descriptionUrd
                    : widget.category.descriptionEng,
                style: const TextStyle(fontSize: 14, color: Colors.black),
                textAlign: TextAlign.justify,
              )
            ],
          );
        }),
      ),
    );
  }
}
