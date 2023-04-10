class Category {
  final int id;
  final String nameEng;
  final String nameUrd;
  final String descriptionEng;
  final String descriptionUrd;
  final String pic;
  final int likes;

  Category(
      {required this.id,
      required this.nameEng,
      required this.nameUrd,
      required this.descriptionEng,
      required this.descriptionUrd,
      required this.pic,
      required this.likes});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        id: json['id'],
        nameEng: json['name_eng'],
        nameUrd: json['name_urd'],
        descriptionEng: json['description_eng'],
        descriptionUrd: json['description_urd'],
        pic: json['pic'],
        likes: json['likes']);
  }
}
