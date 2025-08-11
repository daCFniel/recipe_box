import 'package:flutter/foundation.dart';
import 'package:recipe_box/models/recipe.dart';
import 'package:recipe_box/services/recipe_service.dart';

class RecipeProvider extends ChangeNotifier {
  List<Recipe> _recipes = [];
  bool _isLoading = false;

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;

  RecipeService? _recipeService;

  // Initialize the provider
  Future<void> initialize() async {
    _recipeService = await RecipeService.getInstance();
    await loadRecipes();
  }

  // Load all recipes
  Future<void> loadRecipes() async {
    _isLoading = true;
    notifyListeners();

    try {
      _recipes = await _recipeService!.getRecipes();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new recipe
  Future<void> addRecipe(Recipe recipe) async {
    try {
      await _recipeService!.addRecipe(recipe);
      _recipes.add(recipe);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Update an existing recipe
  Future<void> updateRecipe(Recipe updatedRecipe) async {
    try {
      await _recipeService!.updateRecipe(updatedRecipe);
      final index = _recipes.indexWhere((r) => r.id == updatedRecipe.id);
      if (index != -1) {
        _recipes[index] = updatedRecipe;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  // Delete a recipe
  Future<void> deleteRecipe(String recipeId) async {
    try {
      await _recipeService!.deleteRecipe(recipeId);
      _recipes.removeWhere((r) => r.id == recipeId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Get a recipe by ID (always fresh from the current list)
  Recipe? getRecipeById(String id) {
    try {
      return _recipes.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  // Update a recipe's ingredients (for checkmarks)
  Future<void> updateRecipeIngredients(Recipe recipe) async {
    await updateRecipe(recipe);
  }
}
