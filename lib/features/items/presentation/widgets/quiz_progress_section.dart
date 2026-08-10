import 'package:flutter/material.dart';

class QuizProgressSection extends StatelessWidget {
  final String itemsTitle;
  final int current;
  final int total;
  final double hPad;
  final double screenW;
  final double titleSize;
  final double tagSize;
  final Color rose;

  const QuizProgressSection({
    super.key,
    required this.itemsTitle,
    required this.current,
    required this.total,
    required this.hPad,
    required this.screenW,
    required this.titleSize,
    required this.tagSize,
    required this.rose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // заголовок + счётчик
        Padding(
          padding: EdgeInsets.fromLTRB(
              hPad, screenW * 0.01, hPad, screenW * 0.025),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  itemsTitle,
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                    height: 1.2,
                  ),
                ),
              ),
              Text(
                '${current + 1} / $total',
                style: TextStyle(
                  fontSize: tagSize,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // прогресс-бар
        Padding(
          padding: EdgeInsets.fromLTRB(hPad, 0, hPad, screenW * 0.04),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(screenW * 0.015),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: (current + 1) / total),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: screenW * 0.015,
                backgroundColor: const Color(0x33FDA4AF),
                valueColor: AlwaysStoppedAnimation<Color>(rose),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
