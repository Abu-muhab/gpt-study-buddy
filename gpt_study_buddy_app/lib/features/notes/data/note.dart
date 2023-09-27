class Note {
  Note({
    required this.date,
    this.title,
    this.content,
  });

  final DateTime date;
  final String? title;
  final String? content;

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      date: DateTime.parse(map['date']),
      title: map['title'],
      content: map['content'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'title': title,
      'content': content,
    };
  }

  Note copyWith({
    DateTime? date,
    String? title,
    String? content,
  }) {
    return Note(
      date: date ?? this.date,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }
}
