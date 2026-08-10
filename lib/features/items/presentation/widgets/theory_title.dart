import 'package:flutter/material.dart';

class TheoryTitle extends StatelessWidget {
  final String title;
  final double hPad;
  final double screenW;
  final double titleSize;

  const TheoryTitle({
    super.key,
    required this.title,
    required this.hPad,
    required this.screenW,
    required this.titleSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.fromLTRB(hPad, screenW * 0.01, hPad, screenW * 0.02),
      child: Text(
        title,
        style: TextStyle(
          fontSize: titleSize,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A1A1A),
          height: 1.2,
        ),
      ),
    );
  }
}
