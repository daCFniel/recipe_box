import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:recipe_box/models/recipe.dart';
import 'package:recipe_box/screens/recipe_detail_screen.dart';
import 'package:recipe_box/screens/add_edit_recipe_screen.dart';
import 'package:recipe_box/widgets/recipe_card.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:recipe_box/providers/recipe_provider.dart'; // Import RecipeProvider
import 'package:recipe_box/widgets/gradient_fab.dart'; // Import GradientFab

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the provider and load recipes
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToAddRecipe() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditRecipeScreen(),
      ),
    );
    if (result == true) {
      // No need to call _loadRecipes() here, as the provider will notify listeners
    }
  }

  void _navigateToRecipeDetail(Recipe recipe) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipe: recipe),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  size: 35,
                  Symbols.lunch_dining,
                  color: theme.textTheme.headlineMedium?.color,
                ),
                const SizedBox(width: 8),
                Text(
                  'Recipe Box',
                  style: theme.textTheme.headlineMedium,
                ),
              ],
            ),
            centerTitle: true,
            floating: true, // Make the app bar float
            snap: true, // Make it snap into view
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  // Filter recipes based on the query
                  // This part needs to be updated to filter the provider's recipes
                  // For now, it will just trigger a rebuild.
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Search recipes...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {}); // Trigger rebuild to clear filter
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest,
                ),
              ),
            ),
          ),
          Consumer<RecipeProvider>(
            builder: (context, recipeProvider, child) {
              final filteredRecipes = recipeProvider.recipes.where((recipe) {
                return recipe.title
                        ?.toLowerCase()
                        .contains(_searchController.text.toLowerCase()) ??
                    false;
              }).toList();

              if (recipeProvider.isLoading) {
                return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()));
              } else if (filteredRecipes.isEmpty) {
                return SliverFillRemaining(child: _buildEmptyState(theme));
              } else {
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final recipe = filteredRecipes[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: RecipeCard(
                            recipe: recipe,
                            onTap: () => _navigateToRecipeDetail(recipe),
                          ),
                        ).animate().fade();
                      },
                      childCount: filteredRecipes.length,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: GradientFab(
        onPressed: _navigateToAddRecipe,
        icon: Icons.add,
      ).animate().scale().fadeIn(),
    );
  }

  Widget _buildEmptyState(ThemeData theme) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isEmpty
                  ? 'No recipes yet'
                  : 'No recipes found',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchController.text.isEmpty
                  ? 'Tap the + button to add your first recipe'
                  : 'Try a different search term',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ).animate().fade(duration: 300.ms);
}
