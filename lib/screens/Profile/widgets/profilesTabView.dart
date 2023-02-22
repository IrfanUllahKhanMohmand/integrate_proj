import 'package:flutter/material.dart';

class ProfilesTabView extends StatelessWidget {
  const ProfilesTabView({super.key});

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
                children: const [
                  Text(
                    'Faraz',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  Text(
                    'Syed Ahmad Shah',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  Text(
                    '12 Jan,1931 | Kohat, Pakistan',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  Text(
                    '25 Aug,2008 | Kohat, Pakistan',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ]),
            const SizedBox(height: 20),
            const Text(
              'Syed Ahmad Shah (1931-2008), who acquired the pen name of Faraz, came to be known as Ahmad Faraz as a poet. He was born at Nav Shahra although his ancestral place was Kohat. He studied at Islamia College, Kohat; Edwards College, Peshawar; and Peshawar University from where he got his degrees of M. A. in Urdu and M. A. in Persian. He began his career as a producer in Radio Pakistan. Later, he worked as a lecturer at Islamia College in Peshawar. Faraz disapproved of the military dictatorship in Pakistan and expressed himself unreservedly for which he was arrested. On his release, he preferred to live in a self-imposed exile in Europe and Canada for six years. Back home, he took up senior positions of administrative nature as Resident Director of Pakistan National Centre, and subsequently the Director of Akademy Adabiyat Pakistan, Lok Wirsa and Chairperson of National Book Foundation. A widely respected poet, Faraz received several awards. Some of these include Adamji Award, Abaseen Award, Kamal-e-Fun Award, and Hilal-e-Imtiyaz award, which he returned registering his displeasure with the country’s governance. He was decorated with Hilal-e-Pakistan award by the Government of Pakistan posthumously.  Faraz started writing poetry while he was still a young college student. He emerged as a ghazal poet with an individual signature of his own. Even while he drew upon the traditional subjects of love and romance, he also wrote his age in his poetry with all its despairs and disappointments and produced some of the finest specimens of resistance poetry.  He was a prolific poet with several anthologies to his credit. These include Tanha Tanha, Dard-e-Aashob, Janan Janan, Shubkhoon, Merey Khwab Reza Reza, Beaawara Gali Koochon Mein, Nabeena Shar Mein Aaeena, Pus Andaz Mausam,  and Khwab-e-Gul Pareshan Hai. His translations of poetry are included in Sub Awazein Meri Hain. He also put together a selection from the poetry of Kunwar Mahinder Singh Bedi in Ai Ishq Junoon Pesha. His Kulliyat appeared with an inclusive title of Shahr-e-Sukhan Aaraasta Hai.',
              style: TextStyle(fontSize: 14, color: Colors.black),
              textAlign: TextAlign.justify,
            )
          ],
        ),
      ),
    );
  }
}
