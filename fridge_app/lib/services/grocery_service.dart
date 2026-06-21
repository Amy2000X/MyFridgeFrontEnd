import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/grocery_item.dart';
import 'auth_service.dart';

class GroceryService {
  static const String baseUrl = 'http://127.0.0.1:8000';
  // static const String baseUrl = 'https://myfridgebackend-xsow.onrender.com';

  static Future<List<GroceryItem>> getItems() async {
    final token = AuthService.access_token;
    
    final response = await http.get(
      Uri.parse(
        "$baseUrl/grocery",
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final List<dynamic> data =
        jsonDecode(response.body);

    return data
        .map(
          (e) => GroceryItem.fromJson(e),
        )
        .toList();
  }

  static Future<void> addIngredient( String ingredient, ) async {
    final token = AuthService.access_token;

    await http.post(
      Uri.parse(
        "$baseUrl/grocery",
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "ingredient": ingredient,
      }),
    );
  }

  static Future<void>
      deleteItem(
    String id,
  ) async {
    final token = AuthService.access_token;

    await http.delete(
      Uri.parse(
        "$baseUrl/grocery/$id",
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }
}