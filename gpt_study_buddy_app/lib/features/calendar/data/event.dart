class Event {
  Event({
    required this.startTime,
    required this.endTime,
    required this.isAllDay,
    required this.name,
    required this.id,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      isAllDay: map['isAllDay'],
      name: map['name'],
      id: map['id'],
    );
  }

  final DateTime startTime;
  final DateTime endTime;
  final bool isAllDay;
  final String name;
  final String? id;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'isAllDay': isAllDay,
      'name': name,
      'id': id,
    };
  }

  Event copyWith({
    DateTime? startTime,
    DateTime? endTime,
    bool? isAllDay,
    String? name,
    String? id,
  }) {
    return Event(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAllDay: isAllDay ?? this.isAllDay,
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }
}