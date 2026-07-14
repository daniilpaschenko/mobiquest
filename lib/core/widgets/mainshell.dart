import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({
    super.key,
    required this.navigationShell,
  });

  static const _items = [
    (
      icon: Icons.folder_outlined,
      activeIcon: Icons.folder_rounded,
      label: 'Темы'
    ),
    (
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Главная'
    ),
    (
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Профиль'
    ),
  ];

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenW =
        MediaQuery.of(context).size.width.clamp(0.0, 600.0);

    final double iconSize = screenW * 0.06;
    final double iconBoxSize = screenW * 0.11;
    final double iconBoxRadius = screenW * 0.03;
    final double labelSize = screenW * 0.028;
    final double vertPadding = screenW * 0.02;
    final double gapIconLabel = screenW * 0.01;

    final rose = const Color(0xFFE11D48);
    final roseLight = const Color(0xFFFFF1F2);
    final inactive = Colors.grey.shade400;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: const Border(
            top: BorderSide(
              color: Color.fromARGB(255, 246, 203, 203),
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: vertPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_items.length, (i) {
                final item = _items[i];
                final isActive = i == navigationShell.currentIndex;
                return GestureDetector(
                  onTap: () => _onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                        width: iconBoxSize,
                        height: iconBoxSize,
                        decoration: BoxDecoration(
                          color: isActive ? roseLight : Colors.transparent,
                          borderRadius: BorderRadius.circular(iconBoxRadius),
                        ),
                        child: Center(
                          child: AnimatedScale(
                            scale: isActive ? 1.1 : 1.0, // увеличение
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.elasticOut, // пружинка
                            child: Transform.translate(
                              offset: Offset(0, isActive ? -3 : 0), // лёгкий подъём
                              child: Icon(
                                isActive ? item.activeIcon : item.icon,
                                color: isActive ? rose : inactive,
                                size: iconSize,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: gapIconLabel),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: labelSize,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                          color: isActive ? rose : inactive,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}