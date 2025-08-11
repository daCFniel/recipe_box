import 'package:flutter/material.dart';

class GradientFab extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  const GradientFab({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: Icon(icon, color: theme.colorScheme.onPrimary),
        label: Text(label, style: TextStyle(color: theme.colorScheme.onPrimary)),
      ),
    );
  }
}
