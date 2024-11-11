import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart'; // Pastikan path ini benar
import '../providers/recipe_provider.dart';
import 'recipe_detail_screen.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  String _searchQuery = '';
  String? _selectedCategory;
  bool _showOnlyFavorites = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<RecipeProvider>(context, listen: false).loadPreferences());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeProvider>(
      builder: (context, recipeProvider, child) {
        var recipes = _showOnlyFavorites
            ? recipeProvider.getFavorites()
            : _selectedCategory != null
                ? recipeProvider.getRecipesByCategory(_selectedCategory!)
                : recipeProvider.recipes;

        if (_searchQuery.isNotEmpty) {
          recipes = recipeProvider.searchRecipes(_searchQuery);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Resep Makanan'),
            actions: [
              IconButton(
                icon: Icon(_showOnlyFavorites
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  setState(() {
                    _showOnlyFavorites = !_showOnlyFavorites;
                  });
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Cari Resep',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedCategory,
                  hint: const Text('Pilih Kategori'),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('Semua Kategori'),
                    ),
                    ...recipeProvider.categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return RecipeCard(
                      recipe: recipe,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RecipeDetailScreen(recipe: recipe),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(recipe.image),
        ),
        title: Text(recipe.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipe.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: 16,
                  color: Colors.amber,
                ),
                Text(
                  ' ${recipe.rating.toStringAsFixed(1)} (${recipe.ratingCount})',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 8),
                Text(
                  recipe.category,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(
          recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: recipe.isFavorite ? Colors.red : null,
        ),
        onTap: onTap,
      ),
    );
  }
}
