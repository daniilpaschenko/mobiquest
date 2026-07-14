import 'package:flutter/material.dart';

class ResultView extends StatelessWidget {
  final int score;
  final int total;
  final int? earnedExperience;
  final double screenW;
  final double hPad;
  final double titleSize;
  final double bodySize;
  final double tagSize;
  final double cardRadius;
  final VoidCallback onRestart;
  final VoidCallback onBack;

  static const _rose = Color(0xFFE11D48);
  static const _roseLight = Color(0xFFFFF1F2);
  static const _green = Color(0xFF16A34A);
  static const _greenLight = Color(0xFFF0FDF4);

  const ResultView({
    super.key,
    required this.score,
    required this.total,
    this.earnedExperience,
    required this.screenW,
    required this.hPad,
    required this.titleSize,
    required this.bodySize,
    required this.tagSize,
    required this.cardRadius,
    required this.onRestart,
    required this.onBack,
  });

  bool get _passed => score / total >= 0.6;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            width: screenW * 0.25,
            height: screenW * 0.25,
            decoration: BoxDecoration(
              color: _passed ? _greenLight : _roseLight,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                _passed ? Icons.emoji_events_rounded : Icons.refresh_rounded,
                color: _passed ? _green : _rose,
                size: screenW * 0.12,
              ),
            ),
          ),
          SizedBox(height: screenW * 0.06),
          Text(
            _passed ? 'Отлично!' : 'Попробуй ещё раз',
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: screenW * 0.02),
          Text(
            'Правильных ответов: $score из $total',
            style: TextStyle(
              fontSize: bodySize,
              color: Colors.grey.shade500,
            ),
          ),
          SizedBox(height: screenW * 0.04),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenW * 0.06,
              vertical: screenW * 0.04,
            ),
            decoration: BoxDecoration(
              color: _passed ? _greenLight : _roseLight,
              borderRadius: BorderRadius.circular(cardRadius),
            ),
            child: Text(
              '${(score / total * 100).round()}%',
              style: TextStyle(
                fontSize: screenW * 0.1,
                fontWeight: FontWeight.w800,
                color: _passed ? _green : _rose,
              ),
            ),
          ),
          if (earnedExperience != null) ...[
            SizedBox(height: screenW * 0.04),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenW * 0.04,
                vertical: screenW * 0.02,
              ),
              decoration: BoxDecoration(
                color: _greenLight,
                borderRadius: BorderRadius.circular(cardRadius),
                border: Border.all(color: const Color(0xFF86EFAC)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bolt_rounded, color: _green, size: bodySize * 1.2),
                  SizedBox(width: screenW * 0.015),
                  Text(
                    '+$earnedExperience опыта',
                    style: TextStyle(
                      fontSize: bodySize,
                      fontWeight: FontWeight.w700,
                      color: _green,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            SizedBox(height: screenW * 0.04),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenW * 0.04,
                vertical: screenW * 0.02,
              ),
              decoration: BoxDecoration(
                color: _roseLight,
                borderRadius: BorderRadius.circular(cardRadius),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bolt_rounded, color: _rose, size: bodySize * 1.2),
                  SizedBox(width: screenW * 0.015),
                  Text(
                    'Опыт за эту практику уже получен на сегодня',
                    style: TextStyle(
                      fontSize: bodySize,
                      fontWeight: FontWeight.w700,
                      color: _rose,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: onRestart,
              style: TextButton.styleFrom(
                backgroundColor: _rose,
                padding: EdgeInsets.symmetric(vertical: screenW * 0.038),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(cardRadius),
                ),
              ),
              child: Text(
                'Пройти заново',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: bodySize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: screenW * 0.03),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: onBack,
              style: TextButton.styleFrom(
                backgroundColor: _roseLight,
                padding: EdgeInsets.symmetric(vertical: screenW * 0.038),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(cardRadius),
                ),
              ),
              child: Text(
                'К списку тем',
                style: TextStyle(
                  color: _rose,
                  fontSize: bodySize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: screenW * 0.05),
        ],
      ),
    );
  }
}