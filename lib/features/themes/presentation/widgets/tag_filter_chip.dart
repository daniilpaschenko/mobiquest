import 'package:flutter/material.dart';

class TagFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final double screenW;
  final VoidCallback onTap;

  static const _rose = Color(0xFFE11D48);
  static const _roseLight = Color(0xFFFFF1F2);

  const TagFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.screenW,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? _rose : _roseLight,
      borderRadius: BorderRadius.circular(screenW * 0.03),
      child: InkWell(
        borderRadius: BorderRadius.circular(screenW * 0.03),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenW * 0.03,
            vertical: screenW * 0.018,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                Icon(
                  Icons.check_rounded,
                  size: screenW * 0.032,
                  color: Colors.white,
                ),
                SizedBox(width: screenW * 0.01),
              ],
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                  fontSize: screenW * 0.028,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}