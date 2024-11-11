import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/recipe_list_screen.dart';
import 'providers/recipe_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
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
      title: 'Resep Makanan',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const RecipeListScreen(),
    );
  }
}
