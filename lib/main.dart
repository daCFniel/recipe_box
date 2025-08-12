import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:recipe_box/models/recipe.dart';
import 'package:recipe_box/providers/recipe_provider.dart';
import 'package:recipe_box/screens/home_screen.dart';
import 'package:recipe_box/services/recipe_service.dart';
import 'package:recipe_box/theme.dart';
import 'package:logging/logging.dart'; // Import logging

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Setup logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    if (record.error != null) {
      debugPrint('Error: ${record.error}');
    }
    if (record.stackTrace != null) {
      debugPrint('StackTrace: ${record.stackTrace}');
    }
  });

  // Initialize the database
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [RecipeSchema],
    directory: dir.path,
  );

  // Create the recipe service
  final recipeService = RecipeService(isar);

  // Seed the database with sample data if it's empty
  await recipeService.seedDatabaseWithSampleRecipes();

  runApp(
    ChangeNotifierProvider(
      create: (context) => RecipeProvider(recipeService)..loadRecipes(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Box',
      debugShowCheckedModeBanner: false,
      theme: RecipeBoxTheme.darkTheme,
      home: const HomePage(),
    );
  }
}
