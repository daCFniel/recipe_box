import 'package:flutter/foundation.dart';
import 'package:recipe_box/models/recipe.dart';
import 'package:recipe_box/services/recipe_service.dart';
import 'package:logging/logging.dart'; // Import logging

class RecipeProvider extends ChangeNotifier {
  final RecipeService _recipeService;
  List<Recipe> _recipes = [];
  bool _isLoading = false;
  final _log = Logger('RecipeProvider'); // Create a logger instance

  RecipeProvider(this._recipeService);

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;

  Future<void> loadRecipes() async {
    _isLoading = true;
    notifyListeners();
    try {
      _recipes = await _recipeService.getRecipes();
      _log.info('Recipes loaded successfully. Count: ${_recipes.length}');
    } catch (e, s) {
      _log.severe('Error loading recipes', e, s);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addRecipe(Recipe recipe) async {
    try {
      await _recipeService.saveRecipe(recipe);
      _log.info('Recipe added: ${recipe.title}');
      await loadRecipes(); // Reload all recipes to get the new one with its database-assigned ID
    } catch (e, s) {
      _log.severe('Error adding recipe: ${recipe.title}', e, s);
    }
  }

  Future<void> updateRecipe(Recipe recipe) async {
    try {
      await _recipeService.saveRecipe(recipe);
      _log.info('Recipe updated: ${recipe.title} (ID: ${recipe.id})');
      // Find and update the local recipe to avoid a full reload
      final index = _recipes.indexWhere((r) => r.id == recipe.id);
      if (index != -1) {
        _recipes[index] = recipe;
        notifyListeners();
      } else {
        // If for some reason it wasn't in the list, reload everything
        _log.warning('Updated recipe not found in local list, reloading all recipes.');
        await loadRecipes();
      }
    } catch (e, s) {
      _log.severe('Error updating recipe: ${recipe.title}', e, s);
    }
  }

  Future<void> deleteRecipe(int recipeId) async {
    try {
      final deleted = await _recipeService.deleteRecipe(recipeId);
      if (deleted) {
        _recipes.removeWhere((recipe) => recipe.id == recipeId);
        _log.info('Recipe deleted with ID: $recipeId');
      } else {
        _log.warning('Attempted to delete non-existent recipe from provider with ID: $recipeId');
      }
      notifyListeners();
    } catch (e, s) {
      _log.severe('Error deleting recipe with ID: $recipeId', e, s);
    }
  }

  Recipe? getRecipeById(int id) {
    try {
      final recipe = _recipes.firstWhere((r) => r.id == id);
      _log.fine('Found recipe by ID: $id'); // Use fine for less critical info
      return recipe;
    } catch (e) {
      _log.warning('Recipe with ID: $id not found in local list.');
      return null;
    }
  }

  // Helper to simply trigger a UI update
  void refresh() {
    notifyListeners();
  }
}