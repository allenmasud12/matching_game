/// A model class representing a question and its answer for the matching game.
class Question {
  /// The text of the question.
  final String text;

  /// The correct answer to the question.
  final String answer;

  /// Optional hint for the question.
  final String? hint;

  Question({
    required this.text,
    required this.answer,
    this.hint,
  });

  /// Converts the question to a map for serialization.
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'answer': answer,
      'hint': hint,
    };
  }

  /// Creates a [Question] from a map.
  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      text: map['text']?.toString() ?? '',
      answer: map['answer']?.toString() ?? '',
      hint: map['hint']?.toString(),
    );
  }

  /// Creates a [Question] from a dynamic object with custom field names.
  factory Question.fromDynamic(
      dynamic item, {
        required String Function(dynamic) textExtractor,
        required String Function(dynamic) answerExtractor,
        String? Function(dynamic)? hintExtractor,
      }) {
    return Question(
      text: textExtractor(item),
      answer: answerExtractor(item),
      hint: hintExtractor?.call(item),
    );
  }
}