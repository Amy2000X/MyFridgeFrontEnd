class RecipeItem {
  final Map<String, dynamic> recipe;

  final int totalIngredients;
  final List<String> matchedIngredients;
  final List<String> missingIngredients;

  RecipeItem({
    required this.recipe,

    required this.totalIngredients,
    required this.matchedIngredients,
    required this.missingIngredients,
  });

  factory RecipeItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return RecipeItem(
      recipe: json["recipe"],
      totalIngredients: json["total_ingredients"],
      matchedIngredients:
          List<String>.from(
        json["matched_ingredients"],
      ),
      missingIngredients:
          List<String>.from(
        json["missing_ingredients"],
      ),
    );
  }
}

