import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {
  final String label;
  final int index;
  final bool selected;
  final bool answered;
  final bool isCorrect;
  final double bodySize;
  final double tagSize;
  final double screenW;
  final double cardRadius;
  final VoidCallback onTap;

  static const _rose = Color(0xFFE11D48);
  static const _roseLight = Color(0xFFFFF1F2);
  static const _green = Color(0xFF16A34A);
  static const _greenLight = Color(0xFFF0FDF4);

  const OptionTile({
    super.key,
    required this.label,
    required this.index,
    required this.selected,
    required this.answered,
    required this.isCorrect,
    required this.bodySize,
    required this.tagSize,
    required this.screenW,
    required this.cardRadius,
    required this.onTap,
  });

  Color get _bg {
    if (!answered) return Colors.white;
    if (isCorrect) return _greenLight;
    if (selected) return _roseLight;
    return Colors.white;
  }

  Color get _border {
    if (!answered) return const Color(0xFFE5E7EB);
    if (isCorrect) return const Color(0xFF86EFAC);
    if (selected) return const Color(0xFFFDA4AF);
    return const Color(0xFFE5E7EB);
  }

  Color get _indexBg {
    if (!answered) return const Color(0xFFF3F4F6);
    if (isCorrect) return _green;
    if (selected) return _rose;
    return const Color(0xFFF3F4F6);
  }

  @override
  Widget build(BuildContext context) {
    final letters = ['A', 'B', 'C', 'D'];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(cardRadius),
        border: Border.all(color: _border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(cardRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(cardRadius),
          onTap: answered ? null : onTap,
          child: Padding(
            padding: EdgeInsets.all(screenW * 0.04),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: screenW * 0.08,
                  height: screenW * 0.08,
                  decoration: BoxDecoration(
                    color: _indexBg,
                    borderRadius: BorderRadius.circular(screenW * 0.02),
                  ),
                  child: Center(
                    child: answered && (isCorrect || selected)
                        ? Icon(
                            isCorrect
                                ? Icons.check_rounded
                                : Icons.close_rounded,
                            color: Colors.white,
                            size: screenW * 0.04,
                          )
                        : Text(
                            letters[index],
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
                    label,
                    style: TextStyle(
                      fontSize: bodySize,
                      color: const Color(0xFF1A1A1A),
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w400,
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