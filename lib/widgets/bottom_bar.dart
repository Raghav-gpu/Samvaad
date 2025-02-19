import 'package:bot/pages/user_profile_page.dart';
import 'package:bot/theme.dart';
import 'package:bot/widgets/bottom_bar_icon.dart';
import 'package:flutter/material.dart';
import 'package:bot/pages/new_chat_page.dart';
import 'package:bot/pages/explore_page.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: AppColors.appBar,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 1,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBarIcon(Icons.home_rounded, 0),
            _buildBarIcon(Icons.auto_awesome, 1),
            _buildBarIcon(Icons.map_sharp, 2),
            _buildBarIcon(Icons.person_2_rounded, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildBarIcon(IconData icon, int index) {
    return GestureDetector(
      onTap: () => _handleNavigation(index),
      child: BottomBarIcon(
        icon: icon,
        isSelected: _selectedIndex == index,
      ),
    );
  }

  void _handleNavigation(int index) {
    if (index == _selectedIndex) return;

    setState(() => _selectedIndex = index);

    if (index == 1) {
      _navigateWithAnimation(context, ChatPage());
    } else if (index == 2) {
      _navigateWithAnimation(context, ExplorePage());
    } else if (index == 3) {
      _navigateWithAnimation(context, UserProfilePage());
    }
  }

  void _navigateWithAnimation(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, animation, __) => page,
        transitionsBuilder: (context, animation, _, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.fastOutSlowIn,
          );

          return Stack(
            children: [
              _buildTransitionBackground(curvedAnimation),
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(curvedAnimation),
                child: FadeTransition(
                  opacity: curvedAnimation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.95, end: 1.0)
                        .animate(curvedAnimation),
                    child: child,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ).then((_) => _resetIndex());
  }

  Widget _buildTransitionBackground(Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Colors.blueAccent.withOpacity(animation.value * 0.3),
                Colors.purple.withOpacity(animation.value * 0.1),
              ],
              radius: animation.value * 1.5,
            ),
          ),
        );
      },
    );
  }

  void _resetIndex() {
    if (mounted) setState(() => _selectedIndex = 0);
  }
}
