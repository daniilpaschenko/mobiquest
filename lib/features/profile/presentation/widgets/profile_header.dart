import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.screenW});

  final double screenW;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Профиль',
      style: TextStyle(
        fontSize: screenW * 0.06,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1A1A1A),
      ),
    );
  }
}