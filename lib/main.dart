import 'package:flutter/material.dart';
import 'package:recipe_box/theme.dart';
import 'package:recipe_box/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
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
