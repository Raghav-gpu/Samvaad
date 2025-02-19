import 'package:bot/theme.dart';
import 'package:flutter/material.dart';

class FloatingChatBox extends StatelessWidget {
  final VoidCallback? onTap;

  const FloatingChatBox({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.bottomCenter,
        height: 60,
        width: MediaQuery.of(context).size.width * 0.9, // Responsive width
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppColors.divider,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat,
                color: AppColors.iconSecondary,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(2, 1),
                    blurRadius: 10,
                  ),
                ],
              ),
              const SizedBox(width: 10), // Adds spacing between icon and text
              Text(
                "What do you need help with?",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.iconSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
