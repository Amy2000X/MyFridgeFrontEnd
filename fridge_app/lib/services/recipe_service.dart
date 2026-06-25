import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fridge_app/models/recipe.dart';
import 'package:fridge_app/models/recipe_item.dart';
import 'package:http/http.dart' as http;

import '../models/recipe_match.dart';
import 'auth_service.dart';

class RecipeService {
  // static const String baseUrl = 'https://myfridgebackend-xsow.onrender.com';
  static const String baseUrl = 'http://127.0.0.1:8000';

  static Future<List<Recipe>> getAllRecipes() async {
    final token = AuthService.accessToken;
    
    final response = await http.get(
      Uri.parse(
        "$baseUrl/recipes/",
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to load recipes",
      );
    }

    final List<dynamic> data =
        jsonDecode(response.body);
        // debugPrint(response.body.toString());

    return data
        .map(
          (e) => Recipe.fromJson(e),
        )
        .toList();
  }

  static Future<RecipeItem> getIngredients(int recipeId) async {
    final token = AuthService.accessToken;
    
    final response = await http.get(
      Uri.parse(
        // "$baseUrl/recipes/",
        "$baseUrl/recipes/search/$recipeId",
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to load recipes",
      );
    }

    final List<dynamic> data =
        jsonDecode(response.body);
        // debugPrint(response.body.toString());
        
      

    return RecipeItem.fromJson(data[0]);
  }

  static Future<List<RecipeMatch>> getRecipeSuggestions() async {
    final token = AuthService.accessToken;
    
    final response = await http.get(
      Uri.parse(
        "$baseUrl/recipes/search",
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to load recipes",
      );
    }

    final List<dynamic> data =
        jsonDecode(response.body);

    return data
        .map(
          (e) => RecipeMatch.fromJson(e),
        )
        .toList();
  }

  static Future<Map<String, dynamic>> cookRecipe(int recipeId, bool force,) async {
    final token = AuthService.accessToken;

    final response =
        await http.post(
      Uri.parse(
        "$baseUrl/recipes/cook",
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "recipe_id": recipeId,
        "force": force,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to cook",
      );
    }
    // debugPrint("testing response recipe service");
    // debugPrint(response.toString());
    // debugPrint(response.body.toString());

    return jsonDecode(
      response.body,
    );
  }
}