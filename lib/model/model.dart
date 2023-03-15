class Author {
  final String? penName;
  final String realName;
  final DateTime? birthDate;
  final String? birthPlace;
  final DateTime? deathDate;
  final String? deathPlace;
  final String? intro;
  final String? imageUrl;

  const Author({
    this.penName,
    required this.realName,
    this.birthDate,
    this.birthPlace,
    this.deathDate,
    this.deathPlace,
    this.intro,
    this.imageUrl,
  });
  Map<String, dynamic> toMap() {
    return {
      'penName': penName,
      'realName': realName,
      'birthDate': birthDate!.toIso8601String(),
      'birthPlace': birthPlace,
      'deathDate': deathDate?.toIso8601String(),
      'deathPlace': deathPlace,
      'intro': intro,
      'imageUrl': imageUrl,
    };
  }

  static Author fromMap(Map<String, dynamic> map) {
    return Author(
      penName: map['penName'] ?? "",
      realName: map['realName'],
      birthDate:
          map['deathDate'] != null ? DateTime.parse(map['birthDate']) : null,
      birthPlace: map['birthPlace'] ?? "",
      deathDate:
          map['deathDate'] != null ? DateTime.parse(map['deathDate']) : null,
      deathPlace: map['deathPlace'] ?? "",
      intro: map['intro'] ?? "",
      imageUrl: map['imageUrl'] ?? "",
    );
  }

  @override
  int get hashCode =>
      penName.hashCode ^
      realName.hashCode ^
      birthDate.hashCode ^
      birthPlace.hashCode ^
      deathDate.hashCode ^
      deathPlace.hashCode ^
      intro.hashCode ^
      imageUrl.hashCode;
  @override
  String toString() {
    return 'Author { penName: $penName, realName: $realName, birthDate: $birthDate, birthPlace: $birthPlace, deathDate: $deathDate, deathPlace: $deathPlace, intro: $intro, imageUrl: $imageUrl }';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Author &&
          runtimeType == other.runtimeType &&
          penName == other.penName &&
          realName == other.realName &&
          birthDate == other.birthDate &&
          birthPlace == other.birthPlace &&
          deathDate == other.deathDate &&
          deathPlace == other.deathPlace &&
          intro == other.intro &&
          imageUrl == other.imageUrl;
}
