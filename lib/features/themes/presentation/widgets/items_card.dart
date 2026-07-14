import 'package:flutter/material.dart';
import '../../domain/entities/items_preview.dart';

class ItemsCard extends StatelessWidget {
  final ItemsPreview item;
  final double screenW;
  final VoidCallback onTheory;
  final VoidCallback onPractice;

  const ItemsCard({
    super.key,
    required this.item,
    required this.screenW,
    required this.onTheory,
    required this.onPractice,
  });

  @override
  Widget build(BuildContext context) {
    final double cardRadius = screenW * 0.04;
    final double titleSize = screenW * 0.042;
    final double descSize = screenW * 0.031;
    final double tagSize = screenW * 0.026;
    final double btnSize = screenW * 0.032;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(cardRadius),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(screenW * 0.045),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // заголовок
            Text(
              item.title,
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
            ),

            SizedBox(height: screenW * 0.015),

            // описание
            Text(
              item.description,
              style: TextStyle(
                fontSize: descSize,
                color: Colors.grey.shade500,
                height: 1.45,
              ),
            ),

            SizedBox(height: screenW * 0.03),

            if (item.tags.isNotEmpty) ...[
              SizedBox(height: screenW * 0.01),
              Wrap(
                spacing: screenW * 0.015,
                runSpacing: screenW * 0.01,
                children: item.tags.map((tag) => _TagChip(
                  label: tag,
                  screenW: screenW,
                )).toList(),
              ),
            ],

            SizedBox(height: screenW * 0.035),

            // счётчики
            Row(
              children: [
                _CountBadge(
                  icon: Icons.auto_stories_rounded,
                  label: '${item.theoryCount} раздел(-а/-ов)',
                  screenW: screenW,
                  tagSize: tagSize,
                ),
                SizedBox(width: screenW * 0.02),
                _CountBadge(
                  icon: Icons.bolt_rounded,
                  label: '${item.practiceCount} вопрос(-а/-ов)',
                  screenW: screenW,
                  tagSize: tagSize,
                ),
              ],
            ),

            SizedBox(height: screenW * 0.04),

            // кнопки
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    label: 'Теория',
                    icon: Icons.auto_stories_rounded,
                    filled: false,
                    fontSize: btnSize,
                    screenW: screenW,
                    cardRadius: cardRadius,
                    onTap: onTheory,
                  ),
                ),
                SizedBox(width: screenW * 0.025),
                Expanded(
                  child: _ActionButton(
                    label: 'Практика',
                    icon: Icons.bolt_rounded,
                    filled: true,
                    fontSize: btnSize,
                    screenW: screenW,
                    cardRadius: cardRadius,
                    onTap: onPractice,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// бейдж счётчика

class _CountBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final double screenW;
  final double tagSize;

  static const _rose = Color(0xFFE11D48);
  static const _roseLight = Color(0xFFFFF1F2);

  const _CountBadge({
    required this.icon,
    required this.label,
    required this.screenW,
    required this.tagSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenW * 0.025,
        vertical: screenW * 0.012,
      ),
      decoration: BoxDecoration(
        color: _roseLight,
        borderRadius: BorderRadius.circular(screenW * 0.02),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_rose == _rose ? icon : icon, color: _rose, size: tagSize * 1.1),
          SizedBox(width: screenW * 0.01),
          Text(
            label,
            style: TextStyle(
              fontSize: tagSize,
              color: _rose,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// кнопка действия

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool filled;
  final double fontSize;
  final double screenW;
  final double cardRadius;
  final VoidCallback onTap;

  static const _rose = Color(0xFFE11D48);
  static const _roseLight = Color(0xFFFFF1F2);

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.filled,
    required this.fontSize,
    required this.screenW,
    required this.cardRadius,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? _rose : _roseLight,
      borderRadius: BorderRadius.circular(cardRadius * 0.75),
      child: InkWell(
        borderRadius: BorderRadius.circular(cardRadius * 0.75),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: screenW * 0.032),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: filled ? Colors.white : _rose,
                size: fontSize * 1.15,
              ),
              SizedBox(width: screenW * 0.015),
              Text(
                label,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: filled ? Colors.white : _rose,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// чип с тегом
class _TagChip extends StatelessWidget {
  final String label;
  final double screenW;

  const _TagChip({required this.label, required this.screenW});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenW * 0.02,
        vertical: screenW * 0.007,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(screenW * 0.015),
      ),
      child: Text(
        '#$label',
        style: TextStyle(
          fontSize: screenW * 0.024,
          color: const Color(0xFF6B7280),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}