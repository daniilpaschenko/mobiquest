import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.screenW});

  final double screenW;
  static const _roseLight = Color(0xFFFFF1F2);

  @override
  Widget build(BuildContext context) {
    final double titleSize = screenW * 0.075;
    final double subtitleSize = screenW * 0.036;

    return Row(
      children: [
        Container(
          width: screenW * 0.15,
          height: screenW * 0.15,
          decoration: BoxDecoration(
            color: _roseLight,
            borderRadius: BorderRadius.circular(screenW * 0.04),
          ),
          child: Image.asset(
            'assets/icons/icon.png',
            width: screenW * 0.08,
            height: screenW * 0.08,
          ),
        ),
        SizedBox(width: screenW * 0.035),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MobiQuest',
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1A1A),
                  height: 1.0,
                ),
              ),
              SizedBox(height: screenW * 0.01),
              Text(
                'Тренажёр по мобильной разработке',
                style: TextStyle(
                  fontSize: subtitleSize,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
