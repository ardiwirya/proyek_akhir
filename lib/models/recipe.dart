class Recipe {
  final String title;
  final String description;
  final String image;
  final List<String> ingredients;
  final List<String> steps;
  final String category;
  bool isFavorite;
  double rating;
  int ratingCount;

  Recipe({
    required this.title,
    required this.description,
    required this.image,
    required this.ingredients,
    required this.steps,
    required this.category,
    this.isFavorite = false,
    this.rating = 0.0,
    this.ratingCount = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'ingredients': ingredients,
      'steps': steps,
      'category': category,
      'isFavorite': isFavorite,
      'rating': rating,
      'ratingCount': ratingCount,
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'],
      description: json['description'],
      image: json['image'],
      ingredients: List<String>.from(json['ingredients']),
      steps: List<String>.from(json['steps']),
      category: json['category'],
      isFavorite: json['isFavorite'],
      rating: json['rating'],
      ratingCount: json['ratingCount'],
    );
  }
}
