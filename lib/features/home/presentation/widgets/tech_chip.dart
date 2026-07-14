import 'package:flutter/material.dart';

class TechChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final double screenW;

  static const _rose = Color(0xFFE11D48);
  static const _roseLight = Color(0xFFFFF1F2);

  const TechChip({
    super.key,
    required this.icon,
    required this.label,
    required this.screenW,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenW * 0.03,
        vertical: screenW * 0.018,
      ),
      decoration: BoxDecoration(
        color: _roseLight,
        borderRadius: BorderRadius.circular(screenW * 0.03),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: _rose, size: screenW * 0.035),
          SizedBox(width: screenW * 0.015),
          Text(
            label,
            style: TextStyle(
              fontSize: screenW * 0.03,
              fontWeight: FontWeight.w600,
              color: _rose,
            ),
          ),
        ],
      ),
    );
  }
}
