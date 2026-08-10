import 'package:flutter/material.dart';

class ThemesEmptyState extends StatelessWidget {
  const ThemesEmptyState({
    super.key,
    required this.screenW,
    required this.hasAnyItems,
  });

  final double screenW;
  final bool hasAnyItems;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.folder_open_rounded,
            size: screenW * 0.15,
            color: const Color(0xFFE5E7EB),
          ),
          SizedBox(height: screenW * 0.03),
          Text(
            hasAnyItems ? 'Ничего не найдено' : 'Темы пока не добавлены',
            style: TextStyle(
              fontSize: screenW * 0.032,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}