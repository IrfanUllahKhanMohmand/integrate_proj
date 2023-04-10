class Nazam {
  final int id;
  final String title;
  final String romanTitle;
  final String content;
  final String romanContent;
  final int poetId;
  final int likes;
  Nazam(
      {required this.id,
      required this.title,
      required this.romanTitle,
      required this.content,
      required this.romanContent,
      required this.poetId,
      required this.likes});

  factory Nazam.fromJson(Map<String, dynamic> json) {
    return Nazam(
        id: json['id'],
        title: json['title'],
        romanTitle: json['roman_title'],
        content: json['content'],
        romanContent: json['roman_content'],
        poetId: json['poet_id'],
        likes: json['likes']);
  }
}
