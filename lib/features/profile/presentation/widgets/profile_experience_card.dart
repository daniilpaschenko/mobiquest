import 'package:flutter/material.dart';

class ProfileExperienceCard extends StatelessWidget {
  const ProfileExperienceCard({
    super.key,
    required this.screenW,
    required this.experience,
  });

  final double screenW;
  final int experience;

  static const _rose = Color(0xFFE11D48);
  static const _roseLight = Color(0xFFFFF1F2);

  @override
  Widget build(BuildContext context) {
    final cardRadius = screenW * 0.04;
    final nameSize = screenW * 0.05;
    final bodySize = screenW * 0.033;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenW * 0.05),
      decoration: BoxDecoration(
        color: _roseLight,
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      child: Row(
        children: [
          Container(
            width: screenW * 0.13,
            height: screenW * 0.13,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bolt_rounded,
              color: _rose,
              size: screenW * 0.07,
            ),
          ),
          SizedBox(width: screenW * 0.04),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$experience',
                style: TextStyle(
                  fontSize: nameSize * 1.1,
                  fontWeight: FontWeight.w800,
                  color: _rose,
                ),
              ),
              Text(
                'очков опыта',
                style: TextStyle(
                  fontSize: bodySize,
                  color: _rose,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}