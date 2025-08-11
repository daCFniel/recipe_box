import 'package:flutter/material.dart';
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

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<Recipe> _recipes = [];
  List<Recipe> _filteredRecipes = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadRecipes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
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
    _animationController.forward();
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
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _filterRecipes,
              decoration: InputDecoration(
                hintText: 'Search recipes...',
                prefixIcon: Icon(
                  Icons.search,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          _filterRecipes('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredRecipes.isEmpty
                    ? _buildEmptyState(theme)
                    : FadeTransition(
                        opacity: _fadeAnimation,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe = _filteredRecipes[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: RecipeCard(
                                recipe: recipe,
                                onTap: () => _navigateToRecipeDetail(recipe),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddRecipe,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        icon: const Icon(Icons.add),
        label: const Text('Add Recipe'),
      ),
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
  );
}