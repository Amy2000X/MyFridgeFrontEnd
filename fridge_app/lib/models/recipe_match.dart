class RecipeMatch {
  final Map<String, dynamic> recipe;
  final int matchCount;
  final int totalIngredients;
  final List<String> matchedIngredients;
  final List<String> missingIngredients;

  RecipeMatch({
    required this.recipe,
    required this.matchCount,
    required this.totalIngredients,
    required this.matchedIngredients,
    required this.missingIngredients,
  });

  factory RecipeMatch.fromJson(
    Map<String, dynamic> json,
  ) {
    return RecipeMatch(
      recipe: json["recipe"],
      matchCount: json["match_count"],
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