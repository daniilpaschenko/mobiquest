import 'package:flutter/material.dart';
import '../../domain/entities/theory_section.dart';

class TheoryCard extends StatelessWidget {
  final TheorySection section;
  final int index;
  final bool expanded;
  final VoidCallback onToggle;
  final double cardRadius;
  final double sectionTitleSize;
  final double bodySize;
  final double tagSize;
  final double screenW;

  // static const _rose = Color(0xFFE11D48);

  const TheoryCard({
    super.key,
    required this.section,
    required this.index,
    required this.expanded,
    required this.onToggle,
    required this.cardRadius,
    required this.sectionTitleSize,
    required this.bodySize,
    required this.tagSize,
    required this.screenW,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(cardRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(cardRadius),
          onTap: onToggle,
          child: Padding(
            padding: EdgeInsets.all(screenW * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: screenW * 0.075,
                      height: screenW * 0.075,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(screenW * 0.02),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: tagSize,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: screenW * 0.03),
                    Expanded(
                      child: Text(
                        section.title,
                        style: TextStyle(
                          fontSize: sectionTitleSize,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    Icon(
                      expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey.shade400,
                      size: screenW * 0.055,
                    ),
                  ],
                ),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 250),
                  crossFadeState: expanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: EdgeInsets.only(top: screenW * 0.03),
                    child: Text(
                      section.body,
                      style: TextStyle(
                        fontSize: bodySize,
                        color: Colors.grey.shade700,
                        height: 1.55,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}