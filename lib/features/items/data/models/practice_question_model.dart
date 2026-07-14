import '../../domain/entities/practice_question.dart';

class PracticeQuestionModel extends PracticeQuestion {
  const PracticeQuestionModel({
    required super.id,
    required super.question,
    required super.options,
    required super.correctIndex,
    required super.explanation,
  });

  factory PracticeQuestionModel.fromJson(Map<String, dynamic> json) =>
      PracticeQuestionModel(
        id: json['id'] as String,
        question: json['question'] as String,
        options: List<String>.from(json['options'] as List),
        correctIndex: json['correctIndex'] as int,
        explanation: json['explanation'] as String,
      );
}