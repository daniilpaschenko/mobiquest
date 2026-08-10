import 'package:flutter/material.dart';

class QuizHeader extends StatelessWidget {
  final double hPad;
  final double screenW;
  final double tagSize;
  final Color rose;
  final Color roseLight;
  final VoidCallback onBack;

  const QuizHeader({
    super.key,
    required this.hPad,
    required this.screenW,
    required this.tagSize,
    required this.rose,
    required this.roseLight,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          hPad * 0.5, screenW * 0.02, hPad, screenW * 0.01),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: rose,
            iconSize: screenW * 0.05,
            onPressed: onBack,
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenW * 0.03,
              vertical: screenW * 0.012,
            ),
            decoration: BoxDecoration(
              color: roseLight,
              borderRadius: BorderRadius.circular(screenW * 0.05),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bolt_rounded,
                    color: rose, size: screenW * 0.038),
                SizedBox(width: screenW * 0.012),
                Text(
                  'Практика',
                  style: TextStyle(
                    color: rose,
                    fontSize: tagSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
