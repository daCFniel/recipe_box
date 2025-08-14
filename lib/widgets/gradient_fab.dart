import 'dart:ui';

import 'package:flutter/material.dart';

class GradientFab extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const GradientFab({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.6),
            theme.colorScheme.secondary.withOpacity(0.8),
            theme.colorScheme.tertiary.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 5,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Icon(
          icon,
          color: theme.colorScheme.onPrimary,
          size: 28,
        ),
      ),
    );
  }
}
