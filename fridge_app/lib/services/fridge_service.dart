// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class FridgeService {
//   static const String baseUrl = 'http://127.0.0.1:8000';
//   static Future<List<dynamic>> getFridgeItems(
//     String accessToken,
//   ) async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/fridge-items'),
//       headers: {
//         'Authorization': 'Bearer $accessToken',
//         'Content-Type': 'application/json',
//       },
//     );

//     return jsonDecode(response.body);
//   }
// }

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class FridgeService {
  // static const String baseUrl = 'http://127.0.0.1:8000';
  static const String baseUrl = 'https://myfridgebackend-xsow.onrender.com';
  // final token = AuthService.access_token;

  static Future<List<dynamic>> getItems() async {
    final token = AuthService.access_token;
    debugPrint("Get items in fridge service");
    final response = await http.get(
      Uri.parse('$baseUrl/fridge/items'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',

      },
    );
    debugPrint("Successfully retreived the items");
    // debugPrint(response.toString());

    debugPrint("Status code: ${response.statusCode}");
    debugPrint("Body: ${response.body}");

    final data = jsonDecode(response.body);

    debugPrint("Decoded type: ${data.runtimeType}");
    return jsonDecode(response.body);
  }

  static Future<void> scanBarcode(String ean) async {

    final token = AuthService.access_token;

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
    debugPrint(response.toString());
    debugPrint(response.body.toString());


    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw Exception(response.body);
    }
  }

  static Future<void> addItem(
    Map<String, dynamic> item,
  ) async {
    final token = AuthService.access_token;

    await http.post(
      Uri.parse('$baseUrl/fridge-items'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(item),
    );
  }

  static Future<void> updateItem(
    String id,
    Map<String, dynamic> item,
  ) async {
    final token = AuthService.access_token;

    await http.put(
      Uri.parse('$baseUrl/fridge-items/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(item),
    );
  }

  static Future<void> deleteItem(
    String id,
  ) async {
    final token = AuthService.access_token;


    await http.delete(
      Uri.parse('$baseUrl/fridge-items/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }
}