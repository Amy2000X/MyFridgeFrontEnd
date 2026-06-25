import 'package:flutter/material.dart';
import 'package:fridge_app/models/recipe.dart';
import 'package:fridge_app/screens/recommended_recipe_screen.dart';

import '../services/recipe_service.dart';
import 'recipe_detail_screen.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  late Future<List<Recipe>>
      recipesFuture;

  @override
  void initState() {
    super.initState();

    recipesFuture =
        RecipeService.getAllRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Recipes",
        ),
      ),
      body: FutureBuilder<
          List<Recipe>>(
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

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];

                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(
                          recipe.title,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  RecipeDetailScreen(
                                    recipeId: recipe.id,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const RecommendedRecipeScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Recipes With My Ingredients',
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}