import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenu;

  const AppHeader({super.key, required this.onMenu});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
      backgroundColor: const Color(0xFF060E57),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      automaticallyImplyLeading: false, // Remove the back arrow
      titleSpacing: screenWidth < 600 ? 8 : 20,
      title: Row(
        children: [
          Image.asset(
            'Photos/counselign_logo.png',
            height: screenWidth < 600 ? 30 : 40,
            width: screenWidth < 600 ? 30 : 40,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 10),
          Text(
            'Counselign',
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth < 600 ? 16 : 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          iconSize: screenWidth < 400 ? 22 : 28,
          onPressed: onMenu,
          tooltip: 'Menu',
        ),
      ],
    );
  }
}
