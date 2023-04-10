import 'package:flutter/material.dart';
import 'package:integration_test/Providers/local_provider.dart';
import 'package:integration_test/model/poet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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
          child: Consumer<LocaleProvider>(
            builder: (context, value, child) {
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
                        Text('${AppLocalizations.of(context)!.poet_born}:',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black.withOpacity(0.5))),
                        widget.poet.alive == 0
                            ? Text(
                                '${AppLocalizations.of(context)!.poet_died}:',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black.withOpacity(0.5)))
                            : Container(),
                      ],
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            value.locale!.languageCode == 'ur'
                                ? widget.poet.nameUrd
                                : widget.poet.nameEng,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                          ),
                          Text(
                            '${widget.poet.birthDate} | ${value.locale!.languageCode == 'ur' ? widget.poet.birthCityUrd : widget.poet.birthCityEng}, ${value.locale!.languageCode == 'ur' ? widget.poet.birthCountryUrd : widget.poet.birthCountryEng}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                          ),
                          widget.poet.alive == 0
                              ? Text(
                                  '${widget.poet.deathDate} | ${value.locale!.languageCode == 'ur' ? widget.poet.deathCityUrd : widget.poet.deathCityEng}, ${value.locale!.languageCode == 'ur' ? widget.poet.deathCountryUrd : widget.poet.deathCountryEng}',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ]),
                  const SizedBox(height: 20),
                  Text(
                    value.locale!.languageCode == 'ur'
                        ? widget.poet.descriptionUrd
                        : widget.poet.descriptionEng,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    textAlign: TextAlign.justify,
                  )
                ],
              );
            },
          )),
    );
  }
}
