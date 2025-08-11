import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:recipe_box/models/recipe.dart';
import 'package:recipe_box/services/recipe_service.dart';
import 'package:recipe_box/screens/recipe_detail_screen.dart';
import 'package:recipe_box/screens/add_edit_recipe_screen.dart';
import 'package:recipe_box/widgets/recipe_card.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Recipe> _recipes = [];
  List<Recipe> _filteredRecipes = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRecipes() async {
    setState(() => _isLoading = true);
    final service = await RecipeService.getInstance();
    final recipes = await service.getRecipes();
    setState(() {
      _recipes = recipes;
      _filteredRecipes = recipes;
      _isLoading = false;
    });
  }

  void _filterRecipes(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredRecipes = _recipes;
      } else {
        _filteredRecipes = _recipes
            .where((recipe) =>
                recipe.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _navigateToAddRecipe() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditRecipeScreen(),
      ),
    );
    if (result == true) {
      _loadRecipes();
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
      _loadRecipes();
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
              onChanged: _filterRecipes,
              decoration: InputDecoration(
                hintText: 'Search recipes...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterRecipes('');
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredRecipes.isEmpty
                    ? _buildEmptyState(theme)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredRecipes.length,
                        itemBuilder: (context, index) {
                          final recipe = _filteredRecipes[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: RecipeCard(
                              recipe: recipe,
                              onTap: () => _navigateToRecipeDetail(recipe),
                            ),
                          ).animate().fade();
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddRecipe,
        backgroundColor: Color.fromARGB(255, 118, 89, 146),
        foregroundColor: Color.fromARGB(255, 226, 226, 226),
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
