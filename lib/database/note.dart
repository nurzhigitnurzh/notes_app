class Note {
  final int id;
  final String title;
  final String description;
  final String createdAt;

  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'createdAt': createdAt,
      };

  factory Note.fromMap(Map map) => Note(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        createdAt: map['createdAt'],
      );

  Note copyWith({
    int? id,
    String? title,
    String? description,
    String? createdAt,
  }) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
      );
}