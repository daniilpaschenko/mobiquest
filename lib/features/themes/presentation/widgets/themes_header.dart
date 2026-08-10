import 'package:flutter/material.dart';

class ThemesHeader extends StatelessWidget {
  const ThemesHeader({
    super.key,
    required this.screenW,
    required this.hPad,
  });

  final double screenW;
  final double hPad;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, screenW * 0.05, hPad, screenW * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Темы',
            style: TextStyle(
              fontSize: screenW * 0.06,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: screenW * 0.01),
          Text(
            'Выбери тему — изучи теорию, а затем проверь знания!',
            style: TextStyle(
              fontSize: screenW * 0.032,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}