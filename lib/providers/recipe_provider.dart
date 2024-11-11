import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Perbaiki import
import 'dart:convert' show json;
import '../models/recipe.dart';

class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [
    Recipe(
      title: 'Nasi Goreng',
      description: 'Nasi goreng spesial dengan telur dan sayuran',
      image: 'images/nasi-goreng.jpeg',
      category: 'Makanan Utama',
      ingredients: [
        '2 piring nasi putih',
        '2 butir telur',
        'Sayuran (wortel, kol)',
        'Kecap manis',
        'Bumbu nasi goreng'
      ],
      steps: [
        'Panaskan minyak di wajan',
        'Tumis bumbu hingga harum',
        'Masukkan telur, buat orak-arik',
        'Masukkan nasi dan sayuran',
        'Tambahkan kecap dan aduk rata'
      ],
    ),
    Recipe(
      title: 'Rendang',
      description: 'Rendang daging sapi khas Padang',
      image: 'images/rendang.jpg',
      category: 'Makanan Utama',
      ingredients: [
        '1 kg daging sapi',
        'Santan kelapa',
        'Bumbu rendang',
        'Daun jeruk',
        'Serai'
      ],
      steps: [
        'Potong daging sapi',
        'Tumis bumbu rendang',
        'Masukkan santan dan daging',
        'Masak hingga mengering',
        'Aduk sesekali hingga matang'
      ],
    ),
    Recipe(
      title: 'Sate Ayam',
      description: 'Sate ayam dengan bumbu kacang',
      image: '/images/sate-ayam.jpg',
      category: 'Makanan Utama',
      ingredients: [
        'Daging ayam',
        'Bumbu kacang',
        'Kecap manis',
        'Bawang merah',
        'Cabai rawit'
      ],
      steps: [
        'Potong daging ayam',
        'Tusuk dengan bambu',
        'Bakar hingga matang',
        'Siapkan bumbu kacang',
        'Sajikan dengan lontong'
      ],
    ),
    Recipe(
      title: 'Es Dawet',
      description: 'Minuman tradisional dengan cendol',
      image: 'images/es-dawet.jpeg',
      category: 'Minuman',
      ingredients: ['Cendol', 'Santan', 'Gula merah', 'Es batu', 'Daun pandan'],
      steps: [
        'Siapkan cendol',
        'Rebus santan',
        'Cairkan gula merah',
        'Susun dalam gelas',
        'Tambahkan es batu'
      ],
    ),
  ];

  List<Recipe> get recipes => _recipes;

  List<String> get categories =>
      _recipes.map((recipe) => recipe.category).toSet().toList();

  List<Recipe> getFavorites() {
    return _recipes.where((recipe) => recipe.isFavorite).toList();
  }

  List<Recipe> getRecipesByCategory(String category) {
    return _recipes.where((recipe) => recipe.category == category).toList();
  }

  List<Recipe> searchRecipes(String query) {
    return _recipes
        .where((recipe) =>
            recipe.title.toLowerCase().contains(query.toLowerCase()) ||
            recipe.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<void> toggleFavorite(Recipe recipe) async {
    final index = _recipes.indexWhere((r) => r.title == recipe.title);
    if (index >= 0) {
      _recipes[index].isFavorite = !_recipes[index].isFavorite;
      await _saveFavorites();
      notifyListeners();
    }
  }

  Future<void> rateRecipe(Recipe recipe, double rating) async {
    final index = _recipes.indexWhere((r) => r.title == recipe.title);
    if (index >= 0) {
      _recipes[index].rating =
          ((_recipes[index].rating * _recipes[index].ratingCount) + rating) /
              (_recipes[index].ratingCount + 1);
      _recipes[index].ratingCount++;
      await _saveRatings();
      notifyListeners();
    }
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // Load favorites
    final favoritesJson = prefs.getString('favorites');
    if (favoritesJson != null) {
      final favorites = json.decode(favoritesJson) as List<dynamic>;
      for (var recipe in _recipes) {
        recipe.isFavorite = favorites.contains(recipe.title);
      }
    }

    // Load ratings
    final ratingsJson = prefs.getString('ratings');
    if (ratingsJson != null) {
      final ratings = json.decode(ratingsJson) as Map<String, dynamic>;
      for (var recipe in _recipes) {
        if (ratings.containsKey(recipe.title)) {
          final recipeRating = ratings[recipe.title] as Map<String, dynamic>;
          recipe.rating = recipeRating['rating'];
          recipe.ratingCount = recipeRating['count'];
        }
      }
    }

    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = _recipes
        .where((recipe) => recipe.isFavorite)
        .map((recipe) => recipe.title)
        .toList();
    await prefs.setString('favorites', json.encode(favorites));
  }

  Future<void> _saveRatings() async {
    final prefs = await SharedPreferences.getInstance();
    final ratings = {
      for (var recipe in _recipes)
        recipe.title: {
          'rating': recipe.rating,
          'count': recipe.ratingCount,
        }
    };
    await prefs.setString('ratings', json.encode(ratings));
  }
}
