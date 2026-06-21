class GroceryItem {
  final String id;
  final String ingredient;

  GroceryItem({
    required this.id,
    required this.ingredient,
  });

  factory GroceryItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return GroceryItem(
      id: json["id"],
      ingredient: json["ingredient"],
    );
  }
}