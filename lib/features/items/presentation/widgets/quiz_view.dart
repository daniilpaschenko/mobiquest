import 'package:flutter/material.dart';
import 'shuffled_question.dart';
import 'quiz_header.dart';
import 'quiz_progress_section.dart';
import 'quiz_question_card.dart';
import 'quiz_next_button.dart';

// квиз
class QuizView extends StatelessWidget {
  final List<ShuffledQuestion> questions;
  final int current;
  final int? selected;
  final bool answered;
  final double screenW;
  final double hPad;
  final double titleSize;
  final double questionSize;
  final double bodySize;
  final double tagSize;
  final double cardRadius;
  final String itemsTitle;
  final ValueChanged<int> onSelect;
  final VoidCallback onNext;
  final VoidCallback onBack;

  static const _rose = Color(0xFFE11D48);
  static const _roseLight = Color(0xFFFFF1F2);
  static const _green = Color(0xFF16A34A);
  static const _greenLight = Color(0xFFF0FDF4);

  const QuizView({
    super.key,
    required this.questions,
    required this.current,
    required this.selected,
    required this.answered,
    required this.screenW,
    required this.hPad,
    required this.titleSize,
    required this.questionSize,
    required this.bodySize,
    required this.tagSize,
    required this.cardRadius,
    required this.itemsTitle,
    required this.onSelect,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final q = questions[current];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // хедер
        QuizHeader(
          hPad: hPad,
          screenW: screenW,
          tagSize: tagSize,
          rose: _rose,
          roseLight: _roseLight,
          onBack: onBack,
        ),

        QuizProgressSection(
          itemsTitle: itemsTitle,
          current: current,
          total: questions.length,
          hPad: hPad,
          screenW: screenW,
          titleSize: titleSize,
          tagSize: tagSize,
          rose: _rose,
        ),

        // вопрос + варианты
        Expanded(
          child: QuizQuestionCard(
            question: q.question,
            options: q.options,
            explanation: q.explanation,
            correctIndex: q.correctIndex,
            selected: selected,
            answered: answered,
            screenW: screenW,
            hPad: hPad,
            questionSize: questionSize,
            bodySize: bodySize,
            tagSize: tagSize,
            cardRadius: cardRadius,
            rose: _rose,
            roseLight: _roseLight,
            green: _green,
            greenLight: _greenLight,
            onSelect: onSelect,
          ),
        ),

        // кнопка далее
        if (answered)
          QuizNextButton(
            isLast: current == questions.length - 1,
            hPad: hPad,
            screenW: screenW,
            bodySize: bodySize,
            cardRadius: cardRadius,
            rose: _rose,
            onPressed: onNext,
          ),
      ],
    );
  }
}
