import 'dart:convert';

class Ingredient {
  final String name;
  bool isChecked;

  Ingredient({
    required this.name,
    this.isChecked = false,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'isChecked': isChecked,
  };

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
    name: json['name'] ?? '',
    isChecked: json['isChecked'] ?? false,
  );
}

class Recipe {
  final String id;
  String title;
  String? imagePath;
  String? imageUrl;
  List<Ingredient> ingredients;
  String prepInstructions;
  List<String> cookingSteps;
  DateTime createdAt;
  DateTime updatedAt;

  Recipe({
    required this.id,
    required this.title,
    this.imagePath,
    this.imageUrl,
    List<Ingredient>? ingredients,
    this.prepInstructions = '',
    List<String>? cookingSteps,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : 
    ingredients = ingredients ?? [],
    cookingSteps = cookingSteps ?? [],
    createdAt = createdAt ?? DateTime.now(),
    updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'imagePath': imagePath,
    'imageUrl': imageUrl,
    'ingredients': ingredients.map((i) => i.toJson()).toList(),
    'prepInstructions': prepInstructions,
    'cookingSteps': cookingSteps,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    imagePath: json['imagePath'],
    imageUrl: json['imageUrl'],
    ingredients: (json['ingredients'] as List?)
        ?.map((i) => Ingredient.fromJson(i))
        .toList() ?? [],
    prepInstructions: json['prepInstructions'] ?? '',
    cookingSteps: List<String>.from(json['cookingSteps'] ?? []),
    createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
  );

  String toJsonString() => json.encode(toJson());

  factory Recipe.fromJsonString(String jsonString) =>
      Recipe.fromJson(json.decode(jsonString));

  void resetIngredients() {
    for (final ingredient in ingredients) {
      ingredient.isChecked = false;
    }
    updatedAt = DateTime.now();
  }

  Recipe copyWith({
    String? id,
    String? title,
    String? imagePath,
    String? imageUrl,
    List<Ingredient>? ingredients,
    String? prepInstructions,
    List<String>? cookingSteps,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Recipe(
    id: id ?? this.id,
    title: title ?? this.title,
    imagePath: imagePath ?? this.imagePath,
    imageUrl: imageUrl ?? this.imageUrl,
    ingredients: ingredients ?? this.ingredients,
    prepInstructions: prepInstructions ?? this.prepInstructions,
    cookingSteps: cookingSteps ?? this.cookingSteps,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}