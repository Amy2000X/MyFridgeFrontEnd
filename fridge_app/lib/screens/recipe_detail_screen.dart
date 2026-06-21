import 'package:flutter/material.dart';

import '../models/recipe_match.dart';
import '../services/grocery_service.dart';

class RecipeDetailScreen
    extends StatefulWidget {
  final RecipeMatch recipeMatch;

  const RecipeDetailScreen({
    super.key,
    required this.recipeMatch,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final Set<String> selectedIngredients = {};
  @override
  void initState() {
    super.initState();

    selectedIngredients.addAll(
      widget.recipeMatch
          .missingIngredients,
    );
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
              "Available",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
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
              "Missing",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            Column(
              children: widget
                  .recipeMatch
                  .missingIngredients
                  .map(
                    (ingredient) =>
                        CheckboxListTile(
                      value:
                          selectedIngredients
                              .contains(
                        ingredient,
                      ),
                      title:
                          Text(ingredient),
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
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
                  )
                  .toList(),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.shopping_cart,
                ),
                label: const Text(
                  "Add Selected To Grocery List",
                ),
                onPressed: () async {

                  for (final ingredient
                      in selectedIngredients) {

                    await GroceryService
                        .addIngredient(
                      ingredient,
                    );
                  }

                  if (!mounted) return;

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Added to grocery list",
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(
              height: 24,
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
              recipe["instructions"],
            ),
          ],
        ),
      ),
    );
  }
}