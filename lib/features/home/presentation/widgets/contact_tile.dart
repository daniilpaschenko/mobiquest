import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final double screenW;

  static const _rose = Color(0xFFE11D48);
  static const _roseLight = Color(0xFFFFF1F2);

  const ContactTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.screenW,
  });

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$value скопировано'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _rose,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double cardRadius = screenW * 0.035;
    final double labelSize = screenW * 0.028;
    final double valueSize = screenW * 0.036;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(cardRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(cardRadius),
        onTap: () => _copy(context),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenW * 0.04,
            vertical: screenW * 0.032,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(cardRadius),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              Container(
                width: screenW * 0.09,
                height: screenW * 0.09,
                decoration: const BoxDecoration(
                  color: _roseLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: _rose, size: screenW * 0.045),
              ),
              SizedBox(width: screenW * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: labelSize,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: valueSize,
                        color: const Color(0xFF1A1A1A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.copy_rounded, color: Colors.grey.shade400, size: screenW * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
