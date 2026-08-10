import 'package:flutter/material.dart';

// кнопка-тоггл для фильтров
class FilterToggleButton extends StatelessWidget {
  final bool expanded;
  final int activeCount;
  final double screenW;
  final VoidCallback onTap;

  static const _rose = Color(0xFFE11D48);
  static const _roseLight = Color(0xFFFFF1F2);

  const FilterToggleButton({
    super.key,
    required this.expanded,
    required this.activeCount,
    required this.screenW,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasActive = activeCount > 0;

    return Material(
      color: hasActive ? _rose : _roseLight,
      borderRadius: BorderRadius.circular(screenW * 0.03),
      child: InkWell(
        borderRadius: BorderRadius.circular(screenW * 0.03),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenW * 0.03,
            vertical: screenW * 0.03,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tune_rounded,
                size: screenW * 0.045,
                color: hasActive ? Colors.white : _rose,
              ),
              if (hasActive) ...[
                SizedBox(width: screenW * 0.012),
                Text(
                  '$activeCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: screenW * 0.03,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}