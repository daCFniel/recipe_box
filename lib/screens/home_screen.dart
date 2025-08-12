import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:recipe_box/models/recipe.dart';
import 'package:recipe_box/screens/recipe_detail_screen.dart';
import 'package:recipe_box/screens/add_edit_recipe_screen.dart';
import 'package:recipe_box/widgets/recipe_card.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:recipe_box/providers/recipe_provider.dart'; // Import RecipeProvider

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
    Provider.of<RecipeProvider>(context, listen: false).initialize();
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
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipe: recipe),
      ),
    );
    if (result == true) {
      Provider.of<RecipeProvider>(context, listen: false).loadRecipes();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recipe Box',
          style: theme.textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
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
          Expanded(
            child: Consumer<RecipeProvider>(
              builder: (context, recipeProvider, child) {
                final filteredRecipes = recipeProvider.recipes.where((recipe) {
                  return recipe.title.toLowerCase().contains(_searchController.text.toLowerCase());
                }).toList();

                if (recipeProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (filteredRecipes.isEmpty) {
                  return _buildEmptyState(theme);
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = filteredRecipes[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: RecipeCard(
                          recipe: recipe,
                          onTap: () => _navigateToRecipeDetail(recipe),
                        ),
                      ).animate().fade();
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddRecipe,
        backgroundColor: const Color.fromARGB(255, 118, 89, 146),
        foregroundColor: const Color.fromARGB(255, 226, 226, 226),
        icon: const Icon(Icons.add),
        label: const Text('Add Recipe'),
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