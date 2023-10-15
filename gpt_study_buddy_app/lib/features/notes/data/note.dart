import 'dart:developer';

class Note {
  Note({
    required this.updatedAt,
    this.title,
    this.content,
    this.id,
  });

  final DateTime updatedAt;
  final String? title;
  final String? content;
  final String? id;

  factory Note.fromMap(Map<String, dynamic> map) {
    log(map.toString());
    return Note(
      updatedAt: DateTime.parse(map['updatedAt']),
      title: map['title'],
      content: map['content'],
      id: map['id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'updatedAt': updatedAt.toIso8601String(),
      'title': title,
      'content': content,
    };
  }

  Note copyWith({
    DateTime? updatedAt,
    String? title,
    String? content,
  }) {
    return Note(
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }
}
