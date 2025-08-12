import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_box/models/recipe.dart';

void main() {
  group('Recipe Model', () {
    test('copyWith creates a new instance with updated values', () {
      final originalRecipe = Recipe(
        id: 1,
        title: 'Original Title',
        imagePath: 'path/to/image.jpg',
        ingredients: [Ingredient()..name = 'Sugar'],
        prepInstructions: 'Original Prep',
        cookingSteps: ['Step 1'],
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 1),
      );

      final updatedRecipe = originalRecipe.copyWith(
        title: 'New Title',
        prepInstructions: 'New Prep',
      );

      // Verify new instance is created
      expect(updatedRecipe, isNot(same(originalRecipe)));

      // Verify updated fields
      expect(updatedRecipe.title, 'New Title');
      expect(updatedRecipe.prepInstructions, 'New Prep');

      // Verify unchanged fields
      expect(updatedRecipe.id, originalRecipe.id);
      expect(updatedRecipe.imagePath, originalRecipe.imagePath);
      expect(updatedRecipe.ingredients, originalRecipe.ingredients);
      expect(updatedRecipe.cookingSteps, originalRecipe.cookingSteps);
      expect(updatedRecipe.createdAt, originalRecipe.createdAt);
      expect(updatedRecipe.updatedAt, originalRecipe.updatedAt);
    });

    test('copyWith with null values preserves original values', () {
      final originalRecipe = Recipe(
        id: 1,
        title: 'Original Title',
      );

      final updatedRecipe = originalRecipe.copyWith(
        title: null, // Passing null should preserve original
      );

      expect(updatedRecipe.title, 'Original Title');
    });

    test('resetIngredients sets isChecked to false for all ingredients', () {
      final recipe = Recipe(
        ingredients: [
          Ingredient()..name = 'Flour'..isChecked = true,
          Ingredient()..name = 'Sugar'..isChecked = true,
          Ingredient()..name = 'Eggs'..isChecked = false,
        ],
      );

      final oldUpdatedAt = recipe.updatedAt;
      recipe.resetIngredients();

      expect(recipe.ingredients![0].isChecked, isFalse);
      expect(recipe.ingredients![1].isChecked, isFalse);
      expect(recipe.ingredients![2].isChecked, isFalse);
      expect(recipe.updatedAt, isNot(oldUpdatedAt)); // updatedAt should be updated
    });

    test('resetIngredients handles null ingredients list', () {
      final recipe = Recipe(ingredients: null);
      final oldUpdatedAt = recipe.updatedAt;

      // Should not throw an error
      recipe.resetIngredients();

      expect(recipe.ingredients, isNull);
      expect(recipe.updatedAt, isNot(oldUpdatedAt)); // updatedAt should still be updated
    });
  });
}
