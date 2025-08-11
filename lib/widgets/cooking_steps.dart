import 'package:flutter/material.dart';

class CookingSteps extends StatelessWidget {
  final List<String> steps;

  const CookingSteps({
    super.key,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          for (int i = 0; i < steps.length; i++) ...[
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      steps[i],
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (i < steps.length - 1)
              Container(
                margin: const EdgeInsets.only(left: 24),
                child: Divider(
                  height: 1,
                  thickness: 0.5,
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
          ],
        ],
      ),
    );
  }
}