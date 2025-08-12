import 'package:flutter/material.dart';
import 'package:recipe_box/theme.dart';
import 'package:recipe_box/screens/home_screen.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:recipe_box/providers/recipe_provider.dart'; // Import RecipeProvider

void main() {
  runApp(
    ChangeNotifierProvider( // Wrap MyApp with ChangeNotifierProvider
      create: (context) => RecipeProvider(),
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