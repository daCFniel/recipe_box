import 'package:isar/isar.dart';

part 'recipe.g.dart';

@embedded
class Ingredient {
  String? name;
  bool isChecked = false;

  Ingredient({this.name});
}

@collection
class Recipe {
  Id id = Isar.autoIncrement;
  String? title;
  String? imagePath;
  String? imageUrl;
  List<Ingredient>? ingredients;
  String? prepInstructions;
  List<String>? cookingSteps;
  DateTime? createdAt;
  DateTime? updatedAt;

  // Constructor for creating new recipes
  Recipe({
    this.title,
    this.imagePath,
    this.imageUrl,
    List<Ingredient>? ingredients,
    this.prepInstructions,
    List<String>? cookingSteps,
    this.createdAt,
    this.updatedAt,
  }) : this.ingredients = ingredients ?? [],
       this.cookingSteps = cookingSteps ?? [];

  void resetIngredients() {
    if (ingredients != null) {
      for (final ingredient in ingredients!) {
        ingredient.isChecked = false;
      }
    }
    updatedAt = DateTime.now();
  }

  Recipe copyWith({
    Id? id,
    String? title,
    String? imagePath,
    String? imageUrl,
    List<Ingredient>? ingredients,
    String? prepInstructions,
    List<String>? cookingSteps,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final recipe = Recipe(
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
      ingredients: ingredients ?? this.ingredients,
      prepInstructions: prepInstructions ?? this.prepInstructions,
      cookingSteps: cookingSteps ?? this.cookingSteps,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
    recipe.id = id ?? this.id;
    return recipe;
  }
}