import 'package:flutter/material.dart';

class NazamPreview extends StatelessWidget {
  const NazamPreview({super.key});

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
                  children: const [
                    Text(
                      'ye merī ġhazleñ ye merī nazmeñ',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('AHMAD FARAZ',
                        style: TextStyle(
                            color: Color.fromRGBO(93, 86, 250, 1),
                            fontSize: 12,
                            fontWeight: FontWeight.w500)),
                    Divider(
                      color: Colors.black,
                      thickness: 0.2,
                    ),
                    SizedBox(height: 10),
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
              const Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    'ye merī ġhazleñ ye merī nazmeñ\ntamām terī hikāyateñ haiñ\n\nye tazkire tere lutf ke haiñ\nye sher terī shikāyateñ haiñ\n\nmaiñ sab tirī nazr kar rahā huuñ\nye un zamānoñ kī sā.ateñ haiñ\n\njo zindagī ke na.e safar meñ\ntujhe kisī vaqt yaad aa.eñ\n\nto ek ik harf jī uThegā\npahan ke anfās kī qabā.eñ\n\nudaas tanhā.iyoñ ke lamhoñ\nmeñ naach uTTheñgī ye apsarā.eñ\n\nmujhe tire dard ke alāva bhī\naur dukh the ye māntā huuñ\n\nhazār ġham the jo zindagī kī\ntalāsh meñ the ye jāntā huuñ\n\nmujhe ḳhabar thī ki tere āñchal meñ\ndard kī ret chhāntā huuñ\n\nmagar har ik baar tujh ko chhū kar\nye ret rañg-e-hinā banī hai\n\nye zaḳhm gulzār ban ga.e haiñ\nye āh-e-sozāñ ghaTā banī hai\n\nye dard mauj-e-sabā huā hai\nye aag dil kī sadā banī hai\n\naur ab ye saarī matā-e-hastī\nye phuul ye zaḳhm sab tire haiñ\n\nye dukh ke nauhe ye sukh ke naġhme\njo kal mire the vo ab tire haiñ\n\njo terī qurbat tirī judā.ī\nmeñ kaT ga.e roz-o-shab tire haiñ\n\nvo terā shā.ir tirā muġhannī\nvo jis kī bāteñ ajiib sī thiiñ\n\nvo jis ke andāz ḳhusravāna the\naur adā.eñ ġharīb sī thiiñ\n\nvo jis ke jiine kī ḳhvāhisheñ bhī\nḳhud us ke apne nasīb sī thiiñ\n\nna pūchh is kā ki vo divāna\nbahut dinoñ kā ujaḌ chukā hai\n\nvo kohkan to nahīñ thā lekin\nkaḌī chaTānoñ se laḌ chukā hai\n\nvo thak chukā thā aur us kā tesha\nusī ke siine meñ gaḌ chukā hai ',
                    style: TextStyle(color: Colors.black),
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
