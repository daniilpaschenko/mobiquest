import 'package:flutter/material.dart';
import 'option_tile.dart';
import 'quiz_explanation_box.dart';

class QuizQuestionCard extends StatelessWidget {
  final String question;
  final List<String> options;
  final String explanation;
  final int correctIndex;
  final int? selected;
  final bool answered;
  final double screenW;
  final double hPad;
  final double questionSize;
  final double bodySize;
  final double tagSize;
  final double cardRadius;
  final Color rose;
  final Color roseLight;
  final Color green;
  final Color greenLight;
  final ValueChanged<int> onSelect;

  const QuizQuestionCard({
    super.key,
    required this.question,
    required this.options,
    required this.explanation,
    required this.correctIndex,
    required this.selected,
    required this.answered,
    required this.screenW,
    required this.hPad,
    required this.questionSize,
    required this.bodySize,
    required this.tagSize,
    required this.cardRadius,
    required this.rose,
    required this.roseLight,
    required this.green,
    required this.greenLight,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isCorrect = selected == correctIndex;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(hPad, 0, hPad, screenW * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // карточка вопроса
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(screenW * 0.05),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(cardRadius),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              question,
              style: TextStyle(
                fontSize: questionSize,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
                height: 1.4,
              ),
            ),
          ),

          SizedBox(height: screenW * 0.04),

          // варианты
          ...List.generate(
            options.length,
            (i) => Padding(
              padding: EdgeInsets.only(bottom: screenW * 0.025),
              child: OptionTile(
                label: options[i],
                index: i,
                selected: selected == i,
                answered: answered,
                isCorrect: i == correctIndex,
                bodySize: bodySize,
                tagSize: tagSize,
                screenW: screenW,
                cardRadius: cardRadius,
                onTap: () => onSelect(i),
              ),
            ),
          ),

          // пояснение
          if (answered)
            QuizExplanationBox(
              explanation: explanation,
              isCorrect: isCorrect,
              screenW: screenW,
              bodySize: bodySize,
              cardRadius: cardRadius,
              rose: rose,
              roseLight: roseLight,
              green: green,
              greenLight: greenLight,
            ),
        ],
      ),
    );
  }
}
