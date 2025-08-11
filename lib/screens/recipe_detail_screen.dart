import 'package:flutter/material.dart';
import 'package:recipe_box/models/recipe.dart';
import 'package:recipe_box/services/recipe_service.dart';
import 'package:recipe_box/screens/add_edit_recipe_screen.dart';
import 'package:recipe_box/widgets/ingredients_list.dart';
import 'package:recipe_box/widgets/cooking_steps.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Recipe _recipe;

  @override
  void initState() {
    super.initState();
    _recipe = widget.recipe;
  }

  Future<void> _updateRecipe() async {
    final service = await RecipeService.getInstance();
    await service.updateRecipe(_recipe);
    setState(() {});
  }

  Future<void> _deleteRecipe() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Recipe'),
        content: Text('Are you sure you want to delete "${_recipe.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final service = await RecipeService.getInstance();
      await service.deleteRecipe(_recipe.id);
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  Future<void> _editRecipe() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditRecipeScreen(recipe: _recipe),
      ),
    );
    if (result == true) {
      final service = await RecipeService.getInstance();
      final updatedRecipe = await service.getRecipeById(_recipe.id);
      if (updatedRecipe != null) {
        setState(() => _recipe = updatedRecipe);
      }
    }
  }

  void _resetIngredients() async {
    setState(() {
      _recipe.resetIngredients();
    });
    await _updateRecipe();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingredients reset!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _recipe.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _recipe.imageUrl != null || _recipe.imagePath != null
                      ? _recipe.imageUrl != null
                          ? Image.network(
                              _recipe.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildPlaceholderImage(theme),
                            )
                          : Image.asset(
                              _recipe.imagePath!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildPlaceholderImage(theme),
                            )
                      : _buildPlaceholderImage(theme),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black54,
                        ],
                        stops: [0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                onPressed: _editRecipe,
                icon: const Icon(
                  Icons.edit_rounded,
                  color: Colors.white,
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                onSelected: (value) {
                  switch (value) {
                    case 'delete':
                      _deleteRecipe();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Delete',
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_recipe.prepInstructions.isNotEmpty) ...[
                    _buildSection(
                      title: 'Prep Instructions',
                      icon: Icons.checklist_rtl_rounded,
                      theme: theme,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _recipe.prepInstructions,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (_recipe.ingredients.isNotEmpty) ...[
                    _buildSection(
                      title: 'Ingredients',
                      icon: Icons.list_alt_rounded,
                      theme: theme,
                      action: TextButton.icon(
                        onPressed: _resetIngredients,
                        icon: Icon(
                          Icons.refresh_rounded,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        label: Text(
                          'Reset',
                          style: TextStyle(color: theme.colorScheme.primary),
                        ),
                      ),
                      child: IngredientsList(
                        ingredients: _recipe.ingredients,
                        onIngredientChanged: (ingredient, isChecked) {
                          setState(() {
                            ingredient.isChecked = isChecked;
                          });
                          _updateRecipe();
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (_recipe.cookingSteps.isNotEmpty)
                    _buildSection(
                      title: 'Cooking Instructions',
                      icon: Icons.format_list_numbered_rounded,
                      theme: theme,
                      child: CookingSteps(steps: _recipe.cookingSteps),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required ThemeData theme,
    required Widget child,
    Widget? action,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            if (action != null) action,
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildPlaceholderImage(ThemeData theme) => Container(
    decoration: BoxDecoration(
      color: theme.colorScheme.surfaceContainerHighest,
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu_rounded,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 8),
          Text(
            'No image',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    ),
  );
}