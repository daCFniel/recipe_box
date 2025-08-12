import 'package:isar/isar.dart';
import 'package:recipe_box/models/recipe.dart';
import 'package:logging/logging.dart'; // Import logging

class RecipeService {
  final Isar isar;
  final _log = Logger('RecipeService'); // Create a logger instance

  RecipeService(this.isar);

  Future<List<Recipe>> getRecipes() async {
    try {
      final recipes = await isar.recipes.where().findAll();
      _log.info('Fetched ${recipes.length} recipes.');
      return recipes;
    } catch (e, s) {
      _log.severe('Error fetching recipes', e, s);
      rethrow; // Re-throw to propagate the error
    }
  }

  Future<Recipe?> getRecipeById(int id) async {
    try {
      final recipe = await isar.recipes.get(id);
      _log.info('Fetched recipe with ID: $id');
      return recipe;
    } catch (e, s) {
      _log.severe('Error fetching recipe by ID: $id', e, s);
      rethrow;
    }
  }

  Future<void> saveRecipe(Recipe recipe) async {
    try {
      await isar.writeTxn(() async {
        await isar.recipes.put(recipe);
      });
      _log.info('Recipe saved: ${recipe.title} (ID: ${recipe.id})');
    } catch (e, s) {
      _log.severe('Error saving recipe: ${recipe.title}', e, s);
      rethrow;
    }
  }

  Future<bool> deleteRecipe(int id) async {
    try {
      final deleted = await isar.writeTxn(() async {
        return await isar.recipes.delete(id);
      });
      if (deleted) {
        _log.info('Recipe deleted with ID: $id');
      } else {
        _log.warning('Attempted to delete non-existent recipe with ID: $id');
      }
      return deleted;
    } catch (e, s) {
      _log.severe('Error deleting recipe with ID: $id', e, s);
      rethrow;
    }
  }

  Future<void> seedDatabaseWithSampleRecipes() async {
    try {
      final count = await isar.recipes.count();
      if (count == 0) {
        final sampleRecipes = _getSampleRecipes();
        await isar.writeTxn(() async {
          await isar.recipes.putAll(sampleRecipes);
        });
        _log.info('Database seeded with ${sampleRecipes.length} sample recipes.');
      } else {
        _log.info('Database already contains recipes, skipping seeding.');
      }
    } catch (e, s) {
      _log.severe('Error seeding database with sample recipes', e, s);
      rethrow;
    }
  }

  List<Recipe> _getSampleRecipes() => [
        Recipe(
          title: 'Classic Spaghetti Carbonara',
          imageUrl:
              'https://pixabay.com/get/g216ce050724ca16cfb5aa8eac63ef1c9dfc122234f8cb9413eaf911f220f76b4d5cf87f0ac684e28197343f142ba32fd3d292c5681189ca50331b090824c8fe0_1280.jpg',
          ingredients: [
            Ingredient()..name = '400g spaghetti',
            Ingredient()..name = '200g pancetta or guanciale',
            Ingredient()..name = '4 large eggs',
            Ingredient()..name = '100g Pecorino Romano cheese',
            Ingredient()..name = 'Black pepper',
            Ingredient()..name = 'Salt for pasta water',
          ],
          prepInstructions:
              'Bring a large pot of salted water to boil. Dice the pancetta. Grate the cheese. Whisk eggs with cheese and black pepper in a large bowl.',
          cookingSteps: [
            '🍝 Cook spaghetti according to package directions until al dente',
            '🥓 Meanwhile, cook pancetta in a large skillet until crispy',
            '🥚 Remove skillet from heat and let cool slightly',
            '🍴 Reserve 1 cup pasta water, then drain pasta',
            '🔄 Add hot pasta to skillet with pancetta and toss',
            '🥄 Gradually add egg mixture while tossing to create creamy sauce',
            '💧 Add pasta water as needed to achieve silky consistency',
            '🧀 Serve immediately with extra cheese and black pepper'
          ],
        ),
        Recipe(
          title: 'Honey Garlic Grilled Chicken',
          imageUrl:
              'https://pixabay.com/get/g18e0a0a6e929ef9bc3ae22bcba2f88011a2fed0756664b375a6176b636b6da4f73f54b59aa58c64c6466e2da0e88c68c8d7daf45030aad5e80b526a361d869b9_1280.jpg',
          ingredients: [
            Ingredient()..name = '4 chicken breasts',
            Ingredient()..name = '1/4 cup honey',
            Ingredient()..name = '4 cloves garlic, minced',
            Ingredient()..name = '3 tbsp soy sauce',
            Ingredient()..name = '2 tbsp olive oil',
            Ingredient()..name = '1 tbsp apple cider vinegar',
            Ingredient()..name = 'Salt and pepper to taste',
          ],
          prepInstructions:
              'Pound chicken to even thickness. Mix marinade ingredients. Marinate chicken for at least 30 minutes. Preheat grill to medium-high heat.',
          cookingSteps: [
            '🔥 Preheat grill to medium-high heat',
            '🧄 Mix honey, garlic, soy sauce, oil, and vinegar',
            '🍗 Marinate chicken in mixture for 30+ minutes',
            '🔥 Grill chicken 6-7 minutes per side',
            '🌡️ Cook until internal temperature reaches 165°F',
            '🍯 Brush with reserved marinade while grilling',
            '⏰ Let rest for 5 minutes before serving',
            '🍽️ Serve with your favorite sides'
          ],
        ),
      ];
}