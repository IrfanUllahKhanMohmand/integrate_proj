class Ghazal {
  final int id;
  final String content;
  final String romanContent;
  final int poetId;
  final int likes;

  Ghazal(
      {required this.id,
      required this.content,
      required this.romanContent,
      required this.poetId,
      required this.likes});

  factory Ghazal.fromJson(Map<String, dynamic> json) {
    return Ghazal(
        id: json['id'],
        content: json['content'],
        romanContent: json['roman_content'],
        poetId: json['poet_id'],
        likes: json['likes']);
  }
}
