import 'package:flutter/material.dart';

import '../models/recipe_match.dart';
// import '../services/grocery_service.dart';
import '../services/recipe_service.dart';

class RecipeDetailScreen extends StatefulWidget {
  final RecipeMatch recipeMatch;

  const RecipeDetailScreen({
    super.key,
    required this.recipeMatch,
  });

  @override
  State<RecipeDetailScreen> createState() =>
      _RecipeDetailScreenState();
}

class _RecipeDetailScreenState
    extends State<RecipeDetailScreen> {
  final Set<String> selectedIngredients = {};

  @override
  void initState() {
    super.initState();

    selectedIngredients.addAll(
      widget.recipeMatch.missingIngredients,
    );
  }

  // Future<void> addToGroceryList() async {
  //   try {
  //     await GroceryService.addItems(
  //       selectedIngredients.toList(),
  //     );

  //     if (!mounted) return;

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text(
  //           "Ingredients added to grocery list",
  //         ),
  //       ),
  //     );
  //   } catch (e) {
  //     if (!mounted) return;

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           e.toString(),
  //         ),
  //       ),
  //     );
  //   }
  // }

  Future<void> cookRecipe() async {
    try {
      final recipeId =
          widget.recipeMatch.recipe["id"];

      final response =
          await RecipeService.cookRecipe(
        recipeId,
        false,
      );
      debugPrint("printing cookrecipe response in recipe detail screen");
      debugPrint(response.toString());

      if (response["requires_confirmation"] ==
          true) {
        final confirmed =
            await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text(
              "Missing Ingredients",
            ),
            content: Text(
              response["message"] ??
                  "Some ingredients are missing.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    false,
                  );
                },
                child:
                    const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    true,
                  );
                },
                child:
                    const Text("Continue"),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          final cookResponse =
              await RecipeService.cookRecipe(
            recipeId,
            true,
          );

          if (!mounted) return;

          debugPrint(
            "Final cook response: $cookResponse",
          );

          final deductedIngredients =
              cookResponse["deducted"]
                      as List<dynamic>? ??
                  [];

          final message =
              deductedIngredients.isEmpty
                  ? "No ingredients were deducted."
                  : deductedIngredients
                      .map(
                        (item) =>
                            "• ${item["ingredient"]}: ${item["used"]}",
                      )
                      .join("\n");

          await showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Recipe Cooked"),
              content: Text(
                "The following ingredients were used:\n\n$message",
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }

        return;
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Recipe cooked successfully",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipe =
        widget.recipeMatch.recipe;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          recipe["title"],
        ),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              recipe["title"],
              style:
                  const TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            Text(
              "${widget.recipeMatch.matchCount}/${widget.recipeMatch.totalIngredients} ingredients available",
            ),

            const SizedBox(
              height: 24,
            ),

            const Text(
              "Available Ingredients",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            ...widget.recipeMatch
                .matchedIngredients
                .map(
                  (ingredient) =>
                      ListTile(
                    leading:
                        const Icon(
                      Icons.check,
                      color:
                          Colors.green,
                    ),
                    title: Text(
                      ingredient,
                    ),
                  ),
                ),

            const SizedBox(
              height: 24,
            ),

            const Text(
              "Missing Ingredients",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            ...widget.recipeMatch
                .missingIngredients
                .map(
                  (ingredient) =>
                      CheckboxListTile(
                    value:
                        selectedIngredients
                            .contains(
                      ingredient,
                    ),
                    title: Text(
                      ingredient,
                    ),
                    secondary:
                        const Icon(
                      Icons.close,
                      color:
                          Colors.red,
                    ),
                    onChanged:
                        (value) {
                      setState(() {
                        if (value ==
                            true) {
                          selectedIngredients
                              .add(
                            ingredient,
                          );
                        } else {
                          selectedIngredients
                              .remove(
                            ingredient,
                          );
                        }
                      });
                    },
                  ),
                ),

            const SizedBox(
              height: 16,
            ),

            // SizedBox(
            //   width:
            //       double.infinity,
            //   child:
            //       ElevatedButton.icon(
            //     onPressed:
            //         selectedIngredients
            //                 .isEmpty
            //             ? null
            //             : addToGroceryList,
            //     icon: const Icon(
            //       Icons
            //           .shopping_cart,
            //     ),
            //     label: Text(
            //       "Add ${selectedIngredients.length} items to grocery list",
            //     ),
            //   ),
            // ),

            // const SizedBox(
            //   height: 24,
            // ),

            SizedBox(
              width:
                  double.infinity,
              child:
                  ElevatedButton.icon(
                onPressed:
                    cookRecipe,
                icon: const Icon(
                  Icons
                      .restaurant,
                ),
                label: const Text(
                  "Cook Recipe",
                ),
              ),
            ),

            const SizedBox(
              height: 32,
            ),

            const Text(
              "Instructions",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              recipe["instructions"] ??
                  "",
            ),
          ],
        ),
      ),
    );
  }
}