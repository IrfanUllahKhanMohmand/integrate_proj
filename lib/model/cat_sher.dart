class CatSher {
  final int id;
  final String content;
  final String romanContent;
  final int catId;
  final int likes;
  CatSher(
      {required this.id,
      required this.content,
      required this.romanContent,
      required this.catId,
      required this.likes});

  factory CatSher.fromJson(Map<String, dynamic> json) {
    return CatSher(
        id: json['id'],
        content: json['content'],
        romanContent: json['roman_content'],
        catId: json['cat_id'],
        likes: json['likes']);
  }
}
