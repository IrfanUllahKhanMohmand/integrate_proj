import 'package:flutter/material.dart';

class NazamPreview extends StatelessWidget {
  const NazamPreview({key});

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
              children: [SizedBox(width: 15), Icon(Icons.more_vert)],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'ye merī ġhazleñ ye merī nazmeñ',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('AHMAD FARAZ', style: TextStyle(color: Colors.white)),
                  Divider(
                    color: Colors.white,
                    thickness: 0.2,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            const Text(
              'ye merī ġhazleñ ye merī nazmeñ\ntamām terī hikāyateñ haiñ\n\nye tazkire tere lutf ke haiñ\nye sher terī shikāyateñ haiñ\n\nmaiñ sab tirī nazr kar rahā huuñ\nye un zamānoñ kī sā.ateñ haiñ\n\njo zindagī ke na.e safar meñ\ntujhe kisī vaqt yaad aa.eñ\n\nto ek ik harf jī uThegā\npahan ke anfās kī qabā.eñ\n\nudaas tanhā.iyoñ ke lamhoñ\nmeñ naach uTTheñgī ye apsarā.eñ\n\nmujhe tire dard ke alāva bhī\naur dukh the ye māntā huuñ\n\nhazār ġham the jo zindagī kī\ntalāsh meñ the ye jāntā huuñ\n\nmujhe ḳhabar thī ki tere āñchal meñ\ndard kī ret chhāntā huuñ\n\nmagar har ik baar tujh ko chhū kar\nye ret rañg-e-hinā banī hai\n\nye zaḳhm gulzār ban ga.e haiñ\nye āh-e-sozāñ ghaTā banī hai\n\nye dard mauj-e-sabā huā hai\nye aag dil kī sadā banī hai\n\naur ab ye saarī matā-e-hastī\nye phuul ye zaḳhm sab tire haiñ\n\nye dukh ke nauhe ye sukh ke naġhme\njo kal mire the vo ab tire haiñ\n\njo terī qurbat tirī judā.ī\nmeñ kaT ga.e roz-o-shab tire haiñ\n\nvo terā shā.ir tirā muġhannī\nvo jis kī bāteñ ajiib sī thiiñ\n\nvo jis ke andāz ḳhusravāna the\naur adā.eñ ġharīb sī thiiñ\n\nvo jis ke jiine kī ḳhvāhisheñ bhī\nḳhud us ke apne nasīb sī thiiñ\n\nna pūchh is kā ki vo divāna\nbahut dinoñ kā ujaḌ chukā hai\n\nvo kohkan to nahīñ thā lekin\nkaḌī chaTānoñ se laḌ chukā hai\n\nvo thak chukā thā aur us kā tesha\nusī ke siine meñ gaḌ chukā hai ',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.justify,
            )
          ],
        ),
      ),
    );
  }
}
