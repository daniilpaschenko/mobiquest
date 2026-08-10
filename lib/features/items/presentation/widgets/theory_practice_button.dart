import 'package:flutter/material.dart';

class TheoryPracticeButton extends StatelessWidget {
  final double hPad;
  final double screenW;
  final double bodySize;
  final double cardRadius;
  final Color rose;
  final VoidCallback onPressed;

  const TheoryPracticeButton({
    super.key,
    required this.hPad,
    required this.screenW,
    required this.bodySize,
    required this.cardRadius,
    required this.rose,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, 0, hPad, screenW * 0.05),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            backgroundColor: rose,
            padding: EdgeInsets.symmetric(vertical: screenW * 0.038),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cardRadius),
            ),
          ),
          child: Text(
            'Перейти к практике →',
            style: TextStyle(
              color: Colors.white,
              fontSize: bodySize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
