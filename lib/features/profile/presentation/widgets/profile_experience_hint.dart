import 'package:flutter/material.dart';

class ProfileExperienceHint extends StatelessWidget {
  const ProfileExperienceHint({super.key, required this.screenW});

  final double screenW;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Опыт даётся за первое полностью правильное прохождение практики по теме в течение дня. '
      'В других случаях опыт не начисляется.',
      style: TextStyle(
        fontSize: screenW * 0.033,
        color: Colors.grey.shade500,
        height: 1.5,
      ),
    );
  }
}