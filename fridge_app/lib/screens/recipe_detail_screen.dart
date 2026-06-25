import 'package:flutter/material.dart';

import '../models/recipe_item.dart';
import '../services/recipe_service.dart';

class RecipeDetailScreen extends StatefulWidget {
  final int recipeId;

  const RecipeDetailScreen({
    super.key,
    required this.recipeId,
  });

  @override
  State<RecipeDetailScreen> createState() =>
      _RecipeDetailScreenState();
}

class _RecipeDetailScreenState
    extends State<RecipeDetailScreen> {

  late Future<RecipeItem> recipeItemFuture;

  final Set<String> selectedIngredients = {};

  @override
  void initState() {
    super.initState();

    recipeItemFuture =
        RecipeService.getIngredients(
      widget.recipeId,
    );
  }

  Future<void> cookRecipe(
    RecipeItem recipeItem,
  ) async {
    try {
      final recipeId =
          recipeItem.recipe["id"];

      final response =
          await RecipeService.cookRecipe(
        recipeId,
        false,
      );

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
          await RecipeService.cookRecipe(
            recipeId,
            true,
          );
        }
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
    return Scaffold(
      body: FutureBuilder<RecipeItem>(
        future: recipeItemFuture,
        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          final recipeItem =
              snapshot.data!;

          final recipe =
              recipeItem.recipe;

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

                  ...recipeItem
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

                  ...recipeItem
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
                    height: 24,
                  ),

                  SizedBox(
                    width:
                        double.infinity,
                    child:
                        ElevatedButton.icon(
                      onPressed: () =>
                          cookRecipe(
                        recipeItem,
                      ),
                      icon:
                          const Icon(
                        Icons
                            .restaurant,
                      ),
                      label:
                          const Text(
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
                    recipe[
                            "instructions"] ??
                        "",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}