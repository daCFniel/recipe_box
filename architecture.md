# Recipe Box App Architecture

## Overview
A digital cookbook app that allows users to create and manage personal recipe collections with interactive features including ingredient checklists, prep instructions, and numbered cooking steps.

## Core Features
1. **Recipe Management**: Create, view, edit, and delete recipes
2. **Interactive Ingredients**: Checkbox-based ingredient lists with reset functionality
3. **Recipe Structure**: Title, image, ingredients, prep instructions, and cooking steps
4. **Local Storage**: Persistent data storage using shared_preferences
5. **Image Support**: Recipe photos via image picker
6. **Modern UI**: Card-based design with smooth animations

## Technical Stack
- **Framework**: Flutter with Material 3 design
- **State Management**: StatefulWidget for local state management
- **Storage**: shared_preferences for local data persistence
- **Image Handling**: image_picker for recipe photos
- **Fonts**: Google Fonts (Inter)

## App Structure

### Data Models
1. **Recipe**: Main recipe model with title, image, ingredients, prep, and cooking steps
2. **Ingredient**: Individual ingredient with name and checked state

### Screens
1. **Home Screen**: Recipe list with search and add functionality
2. **Recipe Detail Screen**: Full recipe view with interactive elements
3. **Add/Edit Recipe Screen**: Form for creating/editing recipes

### Key Components
1. **RecipeCard**: Reusable recipe preview card
2. **IngredientsList**: Interactive checklist with reset functionality
3. **CookingSteps**: Numbered list
4. **ImagePicker**: Recipe photo selection component

## File Structure
- `lib/main.dart`: App entry point
- `lib/theme.dart`: App theming (existing)
- `lib/models/recipe.dart`: Data models
- `lib/services/recipe_service.dart`: Data persistence service
- `lib/screens/home_screen.dart`: Recipe list screen
- `lib/screens/recipe_detail_screen.dart`: Recipe viewing screen
- `lib/screens/add_edit_recipe_screen.dart`: Recipe creation/editing
- `lib/widgets/recipe_card.dart`: Recipe preview component
- `lib/widgets/ingredients_list.dart`: Interactive ingredients component
- `lib/widgets/cooking_steps.dart`: Numbered cooking steps component

## Implementation Priority
1. Create data models and storage service
2. Build home screen with recipe list
3. Implement add/edit recipe functionality
4. Create recipe detail screen with interactive elements
5. Add image picker integration
6. Polish UI with animations and final styling
7. Test and debug complete application

## Sample Data
The app will include sample recipes to demonstrate functionality:
- Italian Pasta dishes
- Grilled chicken recipes
- Dessert recipes
- Salad recipes
- Pizza recipes
- Asian stir-fry dishes