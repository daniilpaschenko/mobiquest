import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final double screenW;
  final Color accent;
  final Color accentLight;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    required this.screenW,
    this.accent = const Color(0xFFE11D48),
    this.accentLight = const Color(0xFFFFF1F2),
  });

  @override
  Widget build(BuildContext context) {
    final double cardRadius = screenW * 0.04;
    final double titleSize = screenW * 0.038;
    final double bodySize = screenW * 0.032;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenW * 0.045),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: screenW * 0.1,
            height: screenW * 0.1,
            decoration: BoxDecoration(
              color: accentLight,
              borderRadius: BorderRadius.circular(screenW * 0.025),
            ),
            child: Icon(icon, color: accent, size: screenW * 0.05),
          ),
          SizedBox(width: screenW * 0.035),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: screenW * 0.015),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: bodySize,
                    color: Colors.grey.shade600,
                    height: 1.55,
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
