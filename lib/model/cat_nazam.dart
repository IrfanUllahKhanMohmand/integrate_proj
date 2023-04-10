class CatNazam {
  final int id;
  final String title;
  final String romanTitle;
  final String content;
  final String romanContent;
  final int catId;
  final int likes;

  CatNazam(
      {required this.id,
      required this.title,
      required this.romanTitle,
      required this.content,
      required this.romanContent,
      required this.catId,
      required this.likes});

  factory CatNazam.fromJson(Map<String, dynamic> json) {
    return CatNazam(
        id: json['id'],
        title: json['title'],
        romanTitle: json['roman_title'],
        content: json['content'],
        romanContent: json['roman_content'],
        catId: json['cat_id'],
        likes: json['likes']);
  }
}
