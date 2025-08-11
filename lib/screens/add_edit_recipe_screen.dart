import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_box/models/recipe.dart';
import 'package:recipe_box/services/recipe_service.dart';

class AddEditRecipeScreen extends StatefulWidget {
  final Recipe? recipe;

  const AddEditRecipeScreen({
    super.key,
    this.recipe,
  });

  @override
  State<AddEditRecipeScreen> createState() => _AddEditRecipeScreenState();
}

class _AddEditRecipeScreenState extends State<AddEditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _prepController = TextEditingController();
  final _ingredientControllers = <TextEditingController>[];
  final _stepControllers = <TextEditingController>[];
  final _imagePicker = ImagePicker();
  
  String? _selectedImagePath;
  String? _selectedImageUrl;
  bool _isLoading = false;
  bool _emojifyIngredients = false;
  bool get _isEditing => widget.recipe != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadExistingRecipe();
    } else {
      _addIngredientField();
      _addStepField();
    }
  }

  void _loadExistingRecipe() {
    final recipe = widget.recipe!;
    _titleController.text = recipe.title;
    _prepController.text = recipe.prepInstructions;
    _selectedImagePath = recipe.imagePath;
    _selectedImageUrl = recipe.imageUrl;
    
    // Set emojify to true by default when editing existing recipes
    _emojifyIngredients = true;

    for (final ingredient in recipe.ingredients) {
      final controller = TextEditingController(text: ingredient.name);
      _ingredientControllers.add(controller);
    }

    for (final step in recipe.cookingSteps) {
      final controller = TextEditingController(text: step);
      _stepControllers.add(controller);
    }

    if (_ingredientControllers.isEmpty) _addIngredientField();
    if (_stepControllers.isEmpty) _addStepField();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _prepController.dispose();
    for (final controller in _ingredientControllers) {
      controller.dispose();
    }
    for (final controller in _stepControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addIngredientField() {
    setState(() {
      _ingredientControllers.add(TextEditingController());
    });
  }

  void _removeIngredientField(int index) {
    setState(() {
      _ingredientControllers[index].dispose();
      _ingredientControllers.removeAt(index);
    });
  }

  void _addStepField() {
    setState(() {
      _stepControllers.add(TextEditingController());
    });
  }

  void _removeStepField(int index) {
    setState(() {
      _stepControllers[index].dispose();
      _stepControllers.removeAt(index);
    });
  }

  // Emoji map for common cooking ingredients and terms
  static const Map<String, String> _emojiMap = {
    // Vegetables
    'onion': '🧅',
    'onions': '🧅',
    'tomato': '🍅',
    'tomatoes': '🍅',
    'carrot': '🥕',
    'carrots': '🥕',
    'potato': '🥔',
    'potatoes': '🥔',
    'garlic': '🧄',
    'bell pepper': '🫑',
    'bell peppers': '🫑',
    'corn': '🌽',
    'broccoli': '🥦',
    'cucumber': '🥒',
    'cucumbers': '🥒',
    'eggplant': '🍆',
    'avocado': '🥑',
    'avocados': '🥑',
    'lettuce': '🥬',
    'spinach': '🥬',
    'mushroom': '🍄',
    'mushrooms': '🍄',
    // Fruits
    'apple': '🍎',
    'apples': '🍎',
    'banana': '🍌',
    'bananas': '🍌',
    'orange': '🍊',
    'oranges': '🍊',
    'lemon': '🍋',
    'lemons': '🍋',
    'lime': '🍋',
    'limes': '🍋',
    'strawberry': '🍓',
    'strawberries': '🍓',
    'grape': '🍇',
    'grapes': '🍇',
    'cherry': '🍒',
    'cherries': '🍒',
    'peach': '🍑',
    'peaches': '🍑',
    'watermelon': '🍉',
    'pineapple': '🍍',
    // Proteins
    'chicken': '🍗',
    'beef': '🥩',
    'pork': '🥓',
    'fish': '🐟',
    'salmon': '🐟',
    'shrimp': '🍤',
    'egg': '🥚',
    'eggs': '🥚',
    'bacon': '🥓',
    'ham': '🍖',
    'turkey': '🦃',
    // Dairy
    'milk': '🥛',
    'cheese': '🧀',
    'butter': '🧈',
    'cream': '🥛',
    'yogurt': '🥛',
    // Grains & Carbs
    'bread': '🍞',
    'rice': '🍚',
    'pasta': '🍝',
    'noodles': '🍜',
    'flour': '🌾',
    'wheat': '🌾',
    'oats': '🌾',
    // Herbs & Spices
    'basil': '🌿',
    'parsley': '🌿',
    'cilantro': '🌿',
    'mint': '🌿',
    'rosemary': '🌿',
    'thyme': '🌿',
    'oregano': '🌿',
    'sage': '🌿',
    'salt': '🧂',
    'black pepper': '🌶️',
    'cinnamon': '🟤',
    'vanilla': '🌿',
    // Nuts & Seeds
    'almond': '🥜',
    'almonds': '🥜',
    'peanut': '🥜',
    'peanuts': '🥜',
    'walnut': '🥜',
    'walnuts': '🥜',
    'cashew': '🥜',
    'cashews': '🥜',
    'pistachio': '🥜',
    'pistachios': '🥜',
    // Liquids
    'water': '💧',
    'oil': '🫒',
    'olive oil': '🫒',
    'vinegar': '🍶',
    'wine': '🍷',
    'beer': '🍺',
    'juice': '🧃',
    // Sweet
    'sugar': '🍯',
    'honey': '🍯',
    'syrup': '🍯',
    'chocolate': '🍫',
    'cocoa': '🍫',
    // Other
    'bean': '🫘',
    'beans': '🫘',
    'pea': '🟢',
    'peas': '🟢',
    'nut': '🥜',
    'nuts': '🥜',
    'seed': '🌱',
    'seeds': '🌱',
  };

  String _emojifyText(String text) {
    if (!_emojifyIngredients) return text;
    
    String result = text;
    
    // Process each word in the text
    for (final entry in _emojiMap.entries) {
      final keyword = entry.key;
      final emoji = entry.value;
      
      // Create regex pattern to match the keyword as a whole word
      final pattern = RegExp(r'\b' + RegExp.escape(keyword) + r'\b', caseSensitive: false);
      
      // Replace matches with the keyword + emoji
      result = result.replaceAllMapped(pattern, (match) {
        final matchedText = match.group(0)!;
        final start = match.start;
        final end = match.end;
        
        // Check if emoji already exists immediately after this word
        final textAfter = end < result.length ? result.substring(end) : '';
        final hasEmojiAfter = textAfter.startsWith(' $emoji') || textAfter.startsWith(emoji);
        
        // Only add emoji if it doesn't already exist immediately after this word
        if (!hasEmojiAfter) {
          return '$matchedText $emoji';
        }
        return matchedText;
      });
    }
    
    return result;
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
          _selectedImageUrl = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _saveRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final ingredients = _ingredientControllers
          .map((c) => c.text.trim())
          .where((text) => text.isNotEmpty)
          .map((name) => Ingredient(name: _emojifyText(name)))
          .toList();

      final steps = _stepControllers
          .map((c) => c.text.trim())
          .where((text) => text.isNotEmpty)
          .map((text) => _emojifyText(text))
          .toList();

      final recipe = Recipe(
        id: _isEditing ? widget.recipe!.id : DateTime.now().millisecondsSinceEpoch.toString(),
        title: _emojifyText(_titleController.text.trim()),
        imagePath: _selectedImagePath,
        imageUrl: _selectedImageUrl,
        ingredients: ingredients,
        prepInstructions: _emojifyText(_prepController.text.trim()),
        cookingSteps: steps,
        createdAt: _isEditing ? widget.recipe!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final service = await RecipeService.getInstance();
      
      if (_isEditing) {
        await service.updateRecipe(recipe);
      } else {
        await service.addRecipe(recipe);
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving recipe: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Recipe' : 'Add Recipe'),
        centerTitle: true,
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: _saveRecipe,
              child: Text(
                'Save',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(theme),
              const SizedBox(height: 24),
              _buildTitleField(theme),
              const SizedBox(height: 24),
              _buildPrepSection(theme),
              const SizedBox(height: 24),
              _buildIngredientsSection(theme),
              const SizedBox(height: 24),
              _buildEmojifyCheckbox(theme),
              const SizedBox(height: 24),
              _buildStepsSection(theme),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recipe Image',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                style: BorderStyle.solid,
              ),
            ),
            child: _selectedImagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(_selectedImagePath!),
                      fit: BoxFit.cover,
                    ),
                  )
                : _selectedImageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          _selectedImageUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo_outlined,
                            size: 48,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap to add photo',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField(ThemeData theme) {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: 'Recipe Title',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(
          Icons.restaurant_menu_rounded,
          color: theme.colorScheme.primary,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a recipe title';
        }
        return null;
      },
      textCapitalization: TextCapitalization.words,
    );
  }

  Widget _buildPrepSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prep Instructions',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _prepController,
          decoration: InputDecoration(
            labelText: 'Pre-cooking instructions (optional)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            alignLabelWithHint: true,
          ),
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  Widget _buildIngredientsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ingredients',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton.icon(
              onPressed: _addIngredientField,
              icon: Icon(
                Icons.add,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              label: Text(
                'Add',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (int i = 0; i < _ingredientControllers.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _ingredientControllers[i],
                    decoration: InputDecoration(
                      labelText: 'Ingredient ${i + 1}',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                if (_ingredientControllers.length > 1)
                  IconButton(
                    onPressed: () => _removeIngredientField(i),
                    icon: Icon(
                      Icons.remove_circle_outline,
                      color: theme.colorScheme.error,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildStepsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Cooking Steps',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton.icon(
              onPressed: _addStepField,
              icon: Icon(
                Icons.add,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              label: Text(
                'Add',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (int i = 0; i < _stepControllers.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12, right: 8),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _stepControllers[i],
                    decoration: InputDecoration(
                      labelText: 'Step ${i + 1}',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 2,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                if (_stepControllers.length > 1)
                  IconButton(
                    onPressed: () => _removeStepField(i),
                    icon: Icon(
                      Icons.remove_circle_outline,
                      color: theme.colorScheme.error,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildEmojifyCheckbox(ThemeData theme) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.emoji_emotions_outlined,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Emojify Ingredients',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Automatically add emoji icons to ingredients and steps',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Checkbox(
              value: _emojifyIngredients,
              onChanged: (value) {
                setState(() {
                  _emojifyIngredients = value ?? false;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}