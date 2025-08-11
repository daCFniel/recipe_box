import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipe_box/models/recipe.dart';

class RecipeService {
  static const String _recipesKey = 'recipes';
  static RecipeService? _instance;
  SharedPreferences? _prefs;

  RecipeService._();

  static Future<RecipeService> getInstance() async {
    _instance ??= RecipeService._();
    _instance!._prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  Future<List<Recipe>> getRecipes() async {
    final recipesString = _prefs?.getString(_recipesKey);
    if (recipesString == null || recipesString.isEmpty) {
      return _getSampleRecipes();
    }

    try {
      final List<dynamic> recipesList = json.decode(recipesString);
      return recipesList.map((json) => Recipe.fromJson(json)).toList();
    } catch (e) {
      return _getSampleRecipes();
    }
  }

  Future<void> saveRecipes(List<Recipe> recipes) async {
    final recipesJson = recipes.map((recipe) => recipe.toJson()).toList();
    await _prefs?.setString(_recipesKey, json.encode(recipesJson));
  }

  Future<void> addRecipe(Recipe recipe) async {
    final recipes = await getRecipes();
    recipes.add(recipe);
    await saveRecipes(recipes);
  }

  Future<void> updateRecipe(Recipe updatedRecipe) async {
    final recipes = await getRecipes();
    final index = recipes.indexWhere((r) => r.id == updatedRecipe.id);
    if (index != -1) {
      recipes[index] = updatedRecipe;
      await saveRecipes(recipes);
    }
  }

  Future<void> deleteRecipe(String recipeId) async {
    final recipes = await getRecipes();
    recipes.removeWhere((r) => r.id == recipeId);
    await saveRecipes(recipes);
  }

  Future<Recipe?> getRecipeById(String id) async {
    final recipes = await getRecipes();
    try {
      return recipes.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Recipe> _getSampleRecipes() => [
    Recipe(
      id: '1',
      title: 'Classic Spaghetti Carbonara',
      imageUrl: 'https://pixabay.com/get/g216ce050724ca16cfb5aa8eac63ef1c9dfc122234f8cb9413eaf911f220f76b4d5cf87f0ac684e28197343f142ba32fd3d292c5681189ca50331b090824c8fe0_1280.jpg',
      ingredients: [
        Ingredient(name: '400g spaghetti'),
        Ingredient(name: '200g pancetta or guanciale'),
        Ingredient(name: '4 large eggs'),
        Ingredient(name: '100g Pecorino Romano cheese'),
        Ingredient(name: 'Black pepper'),
        Ingredient(name: 'Salt for pasta water'),
      ],
      prepInstructions: 'Bring a large pot of salted water to boil. Dice the pancetta. Grate the cheese. Whisk eggs with cheese and black pepper in a large bowl.',
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
      id: '2',
      title: 'Honey Garlic Grilled Chicken',
      imageUrl: 'https://pixabay.com/get/g18e0a0a6e929ef9bc3ae22bcba2f88011a2fed0756664b375a6176b636b6da4f73f54b59aa58c64c6466e2da0e88c68c8d7daf45030aad5e80b526a361d869b9_1280.jpg',
      ingredients: [
        Ingredient(name: '4 chicken breasts'),
        Ingredient(name: '1/4 cup honey'),
        Ingredient(name: '4 cloves garlic, minced'),
        Ingredient(name: '3 tbsp soy sauce'),
        Ingredient(name: '2 tbsp olive oil'),
        Ingredient(name: '1 tbsp apple cider vinegar'),
        Ingredient(name: 'Salt and pepper to taste'),
      ],
      prepInstructions: 'Pound chicken to even thickness. Mix marinade ingredients. Marinate chicken for at least 30 minutes. Preheat grill to medium-high heat.',
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
    Recipe(
      id: '3',
      title: 'Decadent Chocolate Cake',
      imageUrl: 'https://pixabay.com/get/g93edb70f8c675e8c0d4b37c470d129345833c0eeb269908be638beb78a9eed8f3fd0d99a0a6c721d7dd28dc1a1da67b22af91d8e108d6cbd62f32c4015d0f5f5_1280.jpg',
      ingredients: [
        Ingredient(name: '2 cups all-purpose flour'),
        Ingredient(name: '2 cups granulated sugar'),
        Ingredient(name: '3/4 cup cocoa powder'),
        Ingredient(name: '2 tsp baking soda'),
        Ingredient(name: '1 tsp baking powder'),
        Ingredient(name: '1 tsp salt'),
        Ingredient(name: '2 eggs'),
        Ingredient(name: '1 cup buttermilk'),
        Ingredient(name: '1 cup hot coffee'),
        Ingredient(name: '1/2 cup vegetable oil'),
      ],
      prepInstructions: 'Preheat oven to 350°F. Grease two 9-inch round pans. Brew hot coffee and let cool slightly. Bring eggs and buttermilk to room temperature.',
      cookingSteps: [
        '🔥 Preheat oven to 350°F (175°C)',
        '🧈 Grease and flour two 9-inch round pans',
        '🥄 Mix all dry ingredients in large bowl',
        '🥚 Whisk together eggs, buttermilk, and oil',
        '🔄 Combine wet and dry ingredients',
        '☕ Gradually stir in hot coffee until smooth',
        '🍰 Divide batter between prepared pans',
        '⏰ Bake 30-35 minutes until toothpick comes out clean',
        '❄️ Cool completely before frosting'
      ],
    ),
    Recipe(
      id: '4',
      title: 'Fresh Mediterranean Salad',
      imageUrl: 'https://pixabay.com/get/g7125b22095ba13dc3da3330849e333b049319dad8dfe783355762a2edb493493db86410e87c542090295ded052e815a0b8aa422b202975c983ba79db19b2ea01_1280.jpg',
      ingredients: [
        Ingredient(name: '2 cups mixed greens'),
        Ingredient(name: '1 cucumber, diced'),
        Ingredient(name: '2 tomatoes, chopped'),
        Ingredient(name: '1/2 red onion, thinly sliced'),
        Ingredient(name: '1/2 cup Kalamata olives'),
        Ingredient(name: '200g feta cheese, crumbled'),
        Ingredient(name: '1/4 cup olive oil'),
        Ingredient(name: '2 tbsp lemon juice'),
        Ingredient(name: '1 tsp dried oregano'),
      ],
      prepInstructions: 'Wash and dry all vegetables. Dice cucumber and tomatoes. Thinly slice red onion. Crumble feta cheese. Make dressing by whisking olive oil, lemon juice, and oregano.',
      cookingSteps: [
        '🥬 Arrange mixed greens in large serving bowl',
        '🥒 Add diced cucumber and chopped tomatoes',
        '🧅 Scatter red onion slices over vegetables',
        '🫒 Add Kalamata olives throughout salad',
        '🧀 Crumble feta cheese on top',
        '🍋 Whisk olive oil, lemon juice, and oregano',
        '🥗 Drizzle dressing over salad',
        '🔄 Toss gently and serve immediately'
      ],
    ),
  ];
}