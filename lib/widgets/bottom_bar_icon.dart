import 'package:bot/theme.dart';
import 'package:flutter/material.dart';

class BottomBarIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;

  const BottomBarIcon({
    super.key,
    required this.icon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Icon(
        icon,
        size: 34,
        color: isSelected ? AppColors.cyan : Colors.white,
        shadows: [
          Shadow(
            color: AppColors.shadow,
            offset: const Offset(4, 5), // Use const here for Offset
            blurRadius: 10,
          )
        ],
      ),
    );
  }
}
