class Poet {
  final int id;
  final String nameEng;
  final String nameUrd;
  final String fatherNameEng;
  final String fatherNameUrd;
  final String birthDate;
  final String deathDate;
  final String birthCityEng;
  final String birthCityUrd;
  final String birthCountryEng;
  final String birthCountryUrd;
  final String deathCityEng;
  final String deathCityUrd;
  final String deathCountryEng;
  final String deathCountryUrd;
  final String descriptionEng;
  final String descriptionUrd;
  final String pic;
  final int alive;
  final int likes;

  Poet(
      {required this.id,
      required this.nameEng,
      required this.nameUrd,
      required this.fatherNameEng,
      required this.fatherNameUrd,
      required this.birthDate,
      required this.deathDate,
      required this.birthCityEng,
      required this.birthCityUrd,
      required this.birthCountryEng,
      required this.birthCountryUrd,
      required this.deathCityEng,
      required this.deathCityUrd,
      required this.deathCountryEng,
      required this.deathCountryUrd,
      required this.descriptionEng,
      required this.descriptionUrd,
      required this.pic,
      required this.alive,
      required this.likes});

  factory Poet.fromJson(Map<String, dynamic> json) {
    return Poet(
      id: json['id'],
      nameEng: json['name_eng'],
      nameUrd: json['name_urd'],
      fatherNameEng: json['father_name_eng'],
      fatherNameUrd: json['father_name_urd'],
      birthDate: json['birth_date'],
      deathDate: json['death_date'],
      birthCityEng: json['birth_city_eng'],
      birthCityUrd: json['birth_city_urd'],
      birthCountryEng: json['birth_country_eng'],
      birthCountryUrd: json['birth_country_urd'],
      deathCityEng: json['death_city_eng'],
      deathCityUrd: json['death_city_urd'],
      deathCountryEng: json['death_country_eng'],
      deathCountryUrd: json['death_country_urd'],
      descriptionEng: json['description_eng'],
      descriptionUrd: json['description_urd'],
      pic: json['pic'],
      alive: json['alive'],
      likes: json['likes'],
    );
  }
}
