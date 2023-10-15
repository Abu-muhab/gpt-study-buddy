class Question {
  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.isRadio,
    required this.attribute,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    final List<QuestionOption> options = <QuestionOption>[];
    for (final Map<String, dynamic> optionMap
        in map['options'] as List<dynamic>) {
      options.add(QuestionOption.fromMap(optionMap));
    }
    return Question(
      id: int.parse(map['id'].toString()),
      question: map['question'] as String,
      isRadio: map['isRadio'] as bool,
      options: options,
      attribute: map['attribute'] as String,
    );
  }

  final int id;
  final String question;
  final bool isRadio;
  final List<QuestionOption> options;
  final String attribute;
}

class QuestionOption {
  QuestionOption({
    required this.id,
    required this.label,
    this.description,
    this.systemDescription,
  });

  factory QuestionOption.fromMap(Map<String, dynamic> map) {
    return QuestionOption(
      id: int.parse(map['id'].toString()),
      label: map['label'] as String,
      description: map['description'] as String?,
      systemDescription: map['systemDescription'] as String?,
    );
  }

  final int id;
  final String label;
  final String? description;
  final String? systemDescription;
}
