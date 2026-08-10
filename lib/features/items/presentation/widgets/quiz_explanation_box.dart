import 'package:flutter/material.dart';

class QuizExplanationBox extends StatelessWidget {
  final String explanation;
  final bool isCorrect;
  final double screenW;
  final double bodySize;
  final double cardRadius;
  final Color rose;
  final Color roseLight;
  final Color green;
  final Color greenLight;

  const QuizExplanationBox({
    super.key,
    required this.explanation,
    required this.isCorrect,
    required this.screenW,
    required this.bodySize,
    required this.cardRadius,
    required this.rose,
    required this.roseLight,
    required this.green,
    required this.greenLight,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(screenW * 0.04),
        decoration: BoxDecoration(
          color: isCorrect ? greenLight : roseLight,
          borderRadius: BorderRadius.circular(cardRadius),
          border: Border.all(
            color: isCorrect
                ? const Color(0xFF86EFAC)
                : const Color(0xFFFDA4AF),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isCorrect ? Icons.check_circle_rounded : Icons.info_rounded,
              color: isCorrect ? green : rose,
              size: screenW * 0.045,
            ),
            SizedBox(width: screenW * 0.025),
            Expanded(
              child: Text(
                explanation,
                style: TextStyle(
                  fontSize: bodySize,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
