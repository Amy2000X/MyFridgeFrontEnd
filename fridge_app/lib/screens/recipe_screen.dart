import 'package:flutter/material.dart';

import '../models/recipe_match.dart';
import '../services/recipe_service.dart';
import 'recipe_detail_screen.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  late Future<List<RecipeMatch>>
      recipesFuture;

  @override
  void initState() {
    super.initState();

    recipesFuture =
        RecipeService.getRecipeSuggestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Recommended Recipes",
        ),
      ),
      body: FutureBuilder<
          List<RecipeMatch>>(
        future: recipesFuture,
        builder:
            (context, snapshot) {
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

          final recipes =
              snapshot.data ?? [];

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder:
                (context, index) {
              final recipe =
                  recipes[index];

              return Card(
                margin:
                    const EdgeInsets.all(
                  8,
                ),
                child: ListTile(
                  title: Text(
                    recipe.recipe["title"],
                  ),
                  subtitle: Text(
                    "${recipe.matchCount}/${recipe.totalIngredients} ingredients available",
                  ),
                  trailing: const Icon(
                    Icons
                        .arrow_forward_ios,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) =>
                                RecipeDetailScreen(
                          recipeMatch:
                              recipe,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}