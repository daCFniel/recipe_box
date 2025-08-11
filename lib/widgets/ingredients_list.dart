import 'package:flutter/material.dart';
import 'package:recipe_box/models/recipe.dart';

class IngredientsList extends StatelessWidget {
  final List<Ingredient> ingredients;
  final Function(Ingredient, bool) onIngredientChanged;

  const IngredientsList({
    super.key,
    required this.ingredients,
    required this.onIngredientChanged,
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
          for (int i = 0; i < ingredients.length; i++) ...[
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  final newValue = !ingredients[i].isChecked;
                  onIngredientChanged(ingredients[i], newValue);
                },
                borderRadius: i == 0
                    ? const BorderRadius.vertical(top: Radius.circular(12))
                    : i == ingredients.length - 1
                        ? const BorderRadius.vertical(bottom: Radius.circular(12))
                        : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          value: ingredients[i].isChecked,
                          onChanged: (value) {
                            if (value != null) {
                              onIngredientChanged(ingredients[i], value);
                            }
                          },
                          activeColor: theme.colorScheme.primary,
                          checkColor: theme.colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: ingredients[i].isChecked
                                ? theme.colorScheme.onSurfaceVariant
                                : theme.colorScheme.onSurface,
                            decoration: ingredients[i].isChecked
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            decorationColor: theme.colorScheme.onSurfaceVariant,
                          ),
                          child: Text(
                            ingredients[i].name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (i < ingredients.length - 1)
              Divider(
                height: 1,
                thickness: 0.5,
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
                indent: 60,
              ),
          ],
        ],
      ),
    );
  }
}