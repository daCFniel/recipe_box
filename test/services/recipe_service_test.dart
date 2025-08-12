import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_box/models/recipe.dart';
import 'package:recipe_box/services/recipe_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('RecipeService', () {
    late RecipeService recipeService;

    // Set up mock preferences for each test
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      recipeService = await RecipeService.getInstance();
    });

    test('getRecipes returns sample recipes when storage is empty', () async {
      // Act
      final recipes = await recipeService.getRecipes();

      // Assert
      // We expect the sample recipes because nothing is in SharedPreferences
      expect(recipes, isA<List<Recipe>>());
      expect(recipes.isNotEmpty, isTrue);
      expect(recipes.first.title, 'Classic Spaghetti Carbonara');
    });

    test('addRecipe saves a new recipe correctly', () async {
      // Arrange
      final newRecipe = Recipe(
        id: 'new-id',
        title: 'Test Recipe',
        ingredients: [Ingredient(name: 'Test Ingredient')],
        prepInstructions: 'Test Prep',
        cookingSteps: ['Test Step 1'],
      );
      // Ensure we start fresh for this specific test's logic
      SharedPreferences.setMockInitialValues({});
      recipeService = await RecipeService.getInstance();

      // Act
      await recipeService.addRecipe(newRecipe);
      final recipes = await recipeService.getRecipes();

      // Assert
      // The service adds the new recipe to the existing sample list
      expect(recipes.length, 5); // 4 samples + 1 new
      expect(recipes.last.title, 'Test Recipe');
    });

    test('getRecipes retrieves saved recipes from SharedPreferences', () async {
      // Arrange
      final testRecipe = Recipe(
          id: 'test-id-1',
          title: 'My Saved Recipe',
          ingredients: [],
          prepInstructions: '',
          cookingSteps: []);
      final List<Map<String, dynamic>> recipeJson = [testRecipe.toJson()];
      SharedPreferences.setMockInitialValues(
          {'recipes': json.encode(recipeJson)});
      recipeService = await RecipeService.getInstance();

      // Act
      final recipes = await recipeService.getRecipes();

      // Assert
      expect(recipes.length, 1);
      expect(recipes.first.title, 'My Saved Recipe');
    });
  });
}