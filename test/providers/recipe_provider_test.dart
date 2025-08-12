import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_box/models/recipe.dart';
import 'package:recipe_box/services/recipe_service.dart';
import 'package:recipe_box/providers/recipe_provider.dart';

// Mock class for RecipeService
class MockRecipeService extends Mock implements RecipeService {}

void main() {
  group('RecipeProvider', () {
    late MockRecipeService mockRecipeService;
    late RecipeProvider recipeProvider;

    setUp(() {
      mockRecipeService = MockRecipeService();
      recipeProvider = RecipeProvider(mockRecipeService);
    });

    test('initial values are correct', () {
      expect(recipeProvider.recipes, isEmpty);
      expect(recipeProvider.isLoading, isFalse);
    });

    group('loadRecipes', () {
      test('sets isLoading to true then false', () async {
        when(mockRecipeService.getRecipes()).thenAnswer((_) async => []);

        final future = recipeProvider.loadRecipes();
        expect(recipeProvider.isLoading, isTrue);
        await future;
        expect(recipeProvider.isLoading, isFalse);
      });

      test('updates recipes list on success', () async {
        final mockRecipes = [
          Recipe(id: 1, title: 'Test Recipe 1'),
          Recipe(id: 2, title: 'Test Recipe 2'),
        ];
        when(mockRecipeService.getRecipes()).thenAnswer((_) async => mockRecipes);

        await recipeProvider.loadRecipes();
        expect(recipeProvider.recipes, mockRecipes);
      });

      test('notifies listeners on state changes', () async {
        when(mockRecipeService.getRecipes()).thenAnswer((_) async => []);

        final listener = MockCallable();
        recipeProvider.addListener(listener);

        await recipeProvider.loadRecipes();
        verify(listener()).called(2); // isLoading true, then false
      });

      test('handles errors during loading', () async {
        when(mockRecipeService.getRecipes()).thenThrow(Exception('Failed to load'));

        await recipeProvider.loadRecipes();
        expect(recipeProvider.recipes, isEmpty); // Should remain empty or handle error state
        expect(recipeProvider.isLoading, isFalse);
        // In a real app, you might want to check for an error message or state
      });
    });

    group('addRecipe', () {
      test('calls saveRecipe on service and reloads recipes', () async {
        final newRecipe = Recipe(id: 3, title: 'New Recipe');
        when(mockRecipeService.saveRecipe(any)).thenAnswer((_) async => {});
        when(mockRecipeService.getRecipes()).thenAnswer((_) async => [newRecipe]);

        await recipeProvider.addRecipe(newRecipe);

        verify(mockRecipeService.saveRecipe(newRecipe)).called(1);
        verify(mockRecipeService.getRecipes()).called(1); // Called by loadRecipes
        expect(recipeProvider.recipes.contains(newRecipe), isTrue);
      });
    });

    group('updateRecipe', () {
      test('calls saveRecipe on service and updates local list', () async {
        final existingRecipe = Recipe(id: 1, title: 'Old Title');
        final updatedRecipe = Recipe(id: 1, title: 'New Title');
        when(mockRecipeService.saveRecipe(any)).thenAnswer((_) async => {});
        when(mockRecipeService.getRecipes()).thenAnswer((_) async => [existingRecipe]);
        await recipeProvider.loadRecipes(); // Populate initial list

        await recipeProvider.updateRecipe(updatedRecipe);

        verify(mockRecipeService.saveRecipe(updatedRecipe)).called(1);
        expect(recipeProvider.recipes.first.title, 'New Title');
        verifyNever(mockRecipeService.getRecipes()); // Should not reload all
      });

      test('reloads if updated recipe not found locally', () async {
        final existingRecipe = Recipe(id: 1, title: 'Old Title');
        final updatedRecipe = Recipe(id: 99, title: 'Non-existent'); // ID not in local list
        when(mockRecipeService.saveRecipe(any)).thenAnswer((_) async => {});
        when(mockRecipeService.getRecipes()).thenAnswer((_) async => [existingRecipe]);
        await recipeProvider.loadRecipes(); // Populate initial list

        when(mockRecipeService.getRecipes()).thenAnswer((_) async => [updatedRecipe]); // Mock reload
        await recipeProvider.updateRecipe(updatedRecipe);

        verify(mockRecipeService.saveRecipe(updatedRecipe)).called(1);
        verify(mockRecipeService.getRecipes()).called(2); // Initial load + reload
        expect(recipeProvider.recipes.first.title, 'Non-existent');
      });
    });

    group('deleteRecipe', () {
      test('calls deleteRecipe on service and removes from local list', () async {
        final recipeToDelete = Recipe(id: 1, title: 'To Delete');
        when(mockRecipeService.deleteRecipe(any)).thenAnswer((_) async => true);
        when(mockRecipeService.getRecipes()).thenAnswer((_) async => [recipeToDelete]);
        await recipeProvider.loadRecipes(); // Populate initial list

        await recipeProvider.deleteRecipe(recipeToDelete.id);

        verify(mockRecipeService.deleteRecipe(recipeToDelete.id)).called(1);
        expect(recipeProvider.recipes, isEmpty);
      });

      test('does not remove from local list if service delete fails', () async {
        final recipeToDelete = Recipe(id: 1, title: 'To Delete');
        when(mockRecipeService.deleteRecipe(any)).thenAnswer((_) async => false); // Simulate failure
        when(mockRecipeService.getRecipes()).thenAnswer((_) async => [recipeToDelete]);
        await recipeProvider.loadRecipes(); // Populate initial list

        await recipeProvider.deleteRecipe(recipeToDelete.id);

        verify(mockRecipeService.deleteRecipe(recipeToDelete.id)).called(1);
        expect(recipeProvider.recipes, isNotEmpty); // Should still be there
      });
    });

    group('getRecipeById', () {
      test('returns recipe if found in local list', () async {
        final mockRecipe = Recipe(id: 1, title: 'Find Me');
        when(mockRecipeService.getRecipes()).thenAnswer((_) async => [mockRecipe]);
        await recipeProvider.loadRecipes();

        final foundRecipe = recipeProvider.getRecipeById(1);
        expect(foundRecipe, mockRecipe);
      });

      test('returns null if recipe not found in local list', () async {
        when(mockRecipeService.getRecipes()).thenAnswer((_) async => []);
        await recipeProvider.loadRecipes();

        final foundRecipe = recipeProvider.getRecipeById(99);
        expect(foundRecipe, isNull);
      });
    });
  });
}

// Helper to mock ChangeNotifier.addListener
class MockCallable extends Mock {
  void call();
}
