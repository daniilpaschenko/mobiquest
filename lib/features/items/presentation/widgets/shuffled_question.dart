import 'dart:math';
import '../../domain/entities/practice_question.dart';

// вопрос с перемешанными вариантами и пересчитанным correctIndex
class ShuffledQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const ShuffledQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  factory ShuffledQuestion.from(PracticeQuestion q) {
    final correctAnswer = q.options[q.correctIndex];
    final shuffled = List<String>.from(q.options)..shuffle(Random());
    return ShuffledQuestion(
      question: q.question,
      options: shuffled,
      correctIndex: shuffled.indexOf(correctAnswer),
      explanation: q.explanation,
    );
  }
}
