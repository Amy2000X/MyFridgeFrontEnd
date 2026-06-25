class Recipe {
  final int id;
  final String title;
  final List<String> ingredients;
  final String instructions;
  final String? imageName;

  Recipe({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    this.imageName,
  });

  factory Recipe.fromJson(
    Map<String, dynamic> json,
  ) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      ingredients: List<String>.from(
        json['ingredients'] ?? [],
      ),
      instructions: json['instructions'],
      imageName: json['image_name'],
    );
  }
}