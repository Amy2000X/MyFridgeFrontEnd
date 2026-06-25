import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class FridgeService {
  // static const String baseUrl = 'https://myfridgebackend-xsow.onrender.com';
  static const String baseUrl = 'http://127.0.0.1:8000';

  static Future<List<dynamic>> getItems() async {
    final token = AuthService.accessToken;
    debugPrint("Get items in fridge service");
    final response = await http.get(
      Uri.parse('$baseUrl/fridge/items'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',

      },
    );

    return jsonDecode(response.body);
  }

  static Future<void> scanBarcode(String ean) async {
    final token = AuthService.accessToken;

    final response = await http.post(
      Uri.parse('$baseUrl/fridge/scan-barcode'),

      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },

      body: jsonEncode({
        "ean": ean,
      }),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw Exception(response.body);
    }
  }

  static Future<void> addItem(Map<String, dynamic> item,) async {
    final token = AuthService.accessToken;

    await http.post(
      Uri.parse('$baseUrl/fridge-items'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(item),
    );
  }

  static Future<void> updateItem(String id, Map<String, dynamic> item,) async {
    final token = AuthService.accessToken;

    await http.put(
      Uri.parse('$baseUrl/fridge-items/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(item),
    );
  }

  static Future<void> deleteItem(String id,) async {
    final token = AuthService.accessToken;

    await http.delete(
      Uri.parse('$baseUrl/fridge-items/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }
}