import 'dart:developer';

class Note {
  Note({
    required this.lastUpdated,
    this.title,
    this.content,
  });

  final DateTime lastUpdated;
  final String? title;
  final String? content;

  factory Note.fromMap(Map<String, dynamic> map) {
    log(map.toString());
    return Note(
      lastUpdated: DateTime.parse(map['lastUpdated']),
      title: map['title'],
      content: map['content'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': lastUpdated.toIso8601String(),
      'title': title,
      'content': content,
    };
  }

  Note copyWith({
    DateTime? lastUpdated,
    String? title,
    String? content,
  }) {
    return Note(
      lastUpdated: lastUpdated ?? this.lastUpdated,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }
}
