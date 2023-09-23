class Bot {
  Bot({
    required this.id,
    required this.slug,
    required this.name,
  });

  final String id;
  final String slug;
  final String name;

  factory Bot.fromMap(Map<String, dynamic> map) {
    return Bot(
      id: map['id'] as String,
      slug: map['slug'] as String,
      name: map['name'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'slug': slug,
      'name': name,
    };
  }
}
